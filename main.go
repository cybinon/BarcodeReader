package main

import (
	"bytes"
	"os/exec"
	"runtime"

	"github.com/gofiber/fiber/v2"
)

func main() {
	app := fiber.New()

	app.Get("/", func(c *fiber.Ctx) error {
		res := runCMD()
		println(res)
		return c.SendString("Hello, World!")
	})
	println("Listening on port 5005")
	app.Listen(":5005")

}

func runCMD() string {
	isWindows := runtime.GOOS == "windows"
	exe, shell, flag := "./BarcodeReaderCLI", "sh", "-c"
	if isWindows {
		exe, shell, flag = ".\\BarcodeReaderCLI.exe", "cmd.exe", "/c"
	}

	args := []string{
		exe,
		// "-type=code128",
		// "https://wabr.inliteresearch.com/SampleImages/1d.pdf",
		"@./brcli-example.config", // Additional options and sources in configuration file
	}

	cmd := ""
	for _, s := range args {
		cmd = cmd + s + " "
	}

	proc := exec.Command(shell, flag, cmd)
	var stdout bytes.Buffer
	var stderr bytes.Buffer
	proc.Stdout = &stdout
	proc.Stderr = &stderr
	proc.Run()

	if stdout.Len() > 0 {
		return stdout.String()
	}
	if stderr.Len() > 0 {
		println("STDERR: \n" + stderr.String())
	}
	return ""
}
