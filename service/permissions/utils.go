package permissions

import (
	"openauth/models/dao"
	"openauth/models/dto"
)

func uniqueShortPermissions(groupPerms, userPermissions []*dao.Permission) []*dto.PermissionDetailsShort {
	uniquemap := make(map[int64]*dto.PermissionDetailsShort)
	for _, p := range groupPerms {
		uniquemap[p.ID] = &dto.PermissionDetailsShort{ID: p.ID, Name: p.Name}
	}
	for _, p := range userPermissions {
		uniquemap[p.ID] = &dto.PermissionDetailsShort{ID: p.ID, Name: p.Name}
	}
	result := make([]*dto.PermissionDetailsShort, 0)
	for _, pds := range uniquemap {
		result = append(result, pds)
	}
	return result
}
