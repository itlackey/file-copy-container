const fs = require("fs");
const { AzCopyClient } = require("@azure-tools/azcopy-node");
const { exec } = require("child_process");

// Read the JSON configuration file
const config = JSON.parse(fs.readFileSync("config.json", "utf8"));

// Mount the drives specified in the configuration file
config.drives.forEach((drive) => {
  const mountCommand = `mount -t cifs -o credentials=/app/keys/${drive.credentials} ${drive.path} /mnt/${drive.name}`;
  exec(mountCommand, (err, stdout, stderr) => {
    if (err) {
      console.error(`Error mounting drive ${drive.name}: ${stderr}`);
    } else {
      console.log(`Drive ${drive.name} mounted successfully`);
    }
  });
});

async function copyFiles() {
  const client = new AzCopyClient();

  // Run the azcopy sync commands in parallel
  return await Promise.all(
    config.commands.map(async (command) => {
      try {
        let jobId = await client.copy(command.source, command.destination, {
          include: command.include,
          exclude: command.exclude,
        });

        let status;
        // You use this job ID to check on the progress of your job, and know if it has finished.
        while (!status || status.StatusType !== "EndOfJob") {
          let jobInfo = await client.getJobInfo(jobId);
          status = jobInfo.latestStatus;
          await new Promise((resolve, reject) => setTimeout(resolve, 1000));
        }
        console.log("Completed", command.source, command.destination);
      } catch (error) {
        console.error(
          "Failed to copy",
          command.source,
          command.destination,
          error
        );
      }
    })
  );
}

copyFiles().then(() => console.log("Done"));
