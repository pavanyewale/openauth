package constants

type Permission string

const (
	// PERMISSIONS

	// able to do any changes
	PERM_SUPER_USER Permission = "SUPER_USER"

	// able to do any changes in user but cannot update permission and groups
	PERM_EDIT_USER   Permission = "EDIT_USER"
	PERM_DELETE_USER Permission = "DELETE_USER"

	// create permission
	PERM_EDIT_PERMISSION   Permission = "EDIT_PERMISSION"
	PERM_DELETE_PERMISSION Permission = "DELETE_PERMISSION"
	// create group
	PERM_EDIT_GROUP   Permission = "EDIT_GROUP"
	PERM_DELETE_GROUP Permission = "DELETE_GROUP"
)

var (
	// PERMISSIONS GROUPS
	EDIT_USER_PERMISSIONS   = map[Permission]bool{PERM_SUPER_USER: true, PERM_EDIT_USER: true}
	DELETE_USER_PERMISSIONS = map[Permission]bool{PERM_SUPER_USER: true, PERM_DELETE_USER: true}

	EDIT_PERMISSIONS_PERMISSIONS   = map[Permission]bool{PERM_SUPER_USER: true, PERM_EDIT_PERMISSION: true}
	DELETE_PERMISSIONS_PERMISSIONS = map[Permission]bool{PERM_SUPER_USER: true, PERM_DELETE_PERMISSION: true}

	EDIT_GROUP_PERMISSIONS   = map[Permission]bool{PERM_SUPER_USER: true, PERM_EDIT_GROUP: true}
	DELETE_GROUP_PERMISSIONS = map[Permission]bool{PERM_SUPER_USER: true, PERM_DELETE_GROUP: true}
)
