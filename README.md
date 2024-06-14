# Task-Scheduler-Time-Fix-Script
Force a windows time sync at login to compensate for a damaged or dead CMOS battery.
Requires the following conditions to work as intended:
  1. The Current User Profile has a Directory named "Logs" within the "Documents" directory.
  2. The User's selected NTP Server is: time.windows.com.

Script is intended to use as a Scheduled Task ran with Administrator Privileges upon Login.
