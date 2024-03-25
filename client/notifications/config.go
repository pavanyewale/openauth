package notifications

type Config struct {
	Name string // mock
}

func (c *Config) validate() {
	if c.Name == "" {
		panic("notifications client name cannot be empty")
	}
}
