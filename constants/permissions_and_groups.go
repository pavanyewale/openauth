package constants

type Permission string

const (
	// PERMISSIONS

	// able to do any changes
	PERM_SUPER_USER Permission = "SUPER_USER"

	// able to do any changes in user but cannot update permission and groups
	PERM_EDIT_USER Permission = "EDIT_USER"

	// create permission
	PERM_EDIT_PERMISSION Permission = "EDIT_PERMISSION"

	// create group
	PERM_EDIT_GROUP Permission = "EDIT_GROUP"

	//assign group and permission
	PERM_ASSIGN_GROUP_PERMISSION Permission = "ASSIGN_GROUP_PERMISSION"
)
