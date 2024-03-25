package otp

import (
	"context"
	"crypto/rand"
	"fmt"
	"math/big"
	"openauth/models/dao"
	"openauth/models/filters"
	"openauth/utils"
	"openauth/utils/customerrors"
	"openauth/utils/logger"
	"time"

	"golang.org/x/crypto/bcrypt"
)

func (s *Service) generateOTP(ctx context.Context) string {

	digits := s.cfg.GetOTPConfig().OTPLength
	max := new(big.Int).Exp(big.NewInt(10), big.NewInt(int64(digits)), nil)
	otp, _ := rand.Int(rand.Reader, max)

	return fmt.Sprintf(fmt.Sprintf("%%0%dd", digits), otp)

}

func (s *Service) sendOTP(ctx context.Context, emailOrMobile string, otp string) error {
	if utils.IsEmail(emailOrMobile) {
		return s.notifClient.SendSMS(
			ctx,
			[]string{emailOrMobile},
			fmt.Sprintf(s.cfg.GetOTPConfig().SMS.Format, otp),
		)
	}
	if utils.IsMobile(emailOrMobile) {
		return s.notifClient.SendEmail(
			ctx,
			[]string{emailOrMobile},
			s.cfg.GetOTPConfig().Email.Subject,
			fmt.Sprintf(s.cfg.GetOTPConfig().Email.BodyFormat, otp),
		)
	}
	return customerrors.BAD_REQUEST_ERROR("invalid email or mobile")
}

func (s *Service) SendOTPOnEmailOrMobile(ctx context.Context, emailOrMobile string) error {
	//checking if otp is already sent on provided email or mobile
	var should_sent bool
	otp, err := s.repo.GetLatestOTPByFilter(ctx, &filters.OTPFilter{To: emailOrMobile})
	if err != nil {
		if !customerrors.IS_RECORD_NOT_FOUND_ERROR(err) {
			return err
		}
		should_sent = true
	} else {
		if otp.Expriry < time.Now().UnixMilli() {
			should_sent = true
		}
	}
	if !should_sent {
		logger.Debug(ctx, "otp already sent on %s so skipping", emailOrMobile)
		return nil
	}
	otpStr := s.generateOTP(ctx)

	if err = s.sendOTP(ctx, emailOrMobile, otpStr); err != nil {
		return err
	}

	err = s.repo.CreateOTP(ctx, &dao.Otp{
		SentTo:    emailOrMobile,
		OTP:       otpStr,
		Expriry:   time.Now().Add(time.Second * 60 * time.Duration(s.cfg.GetOTPConfig().ResendOTPInMins)).UnixMilli(),
		CreatedOn: time.Now().UnixMilli(),
		UpdatedOn: time.Now().UnixMilli(),
	})
	if err != nil {
		return err
	}
	return nil
}

func (s *Service) ValidateOtp(ctx context.Context, emailOrMobile string, otp string) error {
	latestOtp, err := s.repo.GetLatestOTPByFilter(ctx, &filters.OTPFilter{To: emailOrMobile})
	if err != nil {
		if customerrors.IS_RECORD_NOT_FOUND_ERROR(err) {
			return customerrors.BAD_REQUEST_ERROR("invalid email/mobile/otp")
		}
		return err
	}
	if latestOtp.Expriry < time.Now().UnixMilli() {
		return customerrors.BAD_REQUEST_ERROR("invalid email/mobile/otp")
	}
	if s.cfg.GetOTPConfig().HashOTP {
		err = bcrypt.CompareHashAndPassword([]byte(latestOtp.OTP), []byte(otp))
		if err != nil {
			return customerrors.BAD_REQUEST_ERROR("invalid email/mobile/otp")
		}
	} else {
		if latestOtp.OTP != otp {
			return customerrors.BAD_REQUEST_ERROR("invalid email/mobile/otp")
		}
	}
	return nil
}
