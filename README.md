# mcka

### More Commonly Known As

#### (Multipass Cloud-Config KinD) &times; And

How to use the resources provided here to spin up a single local VM and stand up a multi node Kubernetes cluster for your self upskilling in 40 seconds.

### For Windows 10 Pro

1. If you have Windows 10 Pro, enable Hyper-V. Follow instructions at https://learn.microsoft.com/en-us/windows-server/virtualization/hyper-v/get-started/Install-Hyper-V?pivots=windows

2. Install `multipass`, please refer to https://canonical.com/multipass/install for instructions on your Operatting System.

3. Run the following command in Powershell.

> <pre>$Url = 'https://github.com/tsanghan/mcka/releases/latest/download/cloud-config-hyperv.yaml'
> $Name = kind
> multipass launch --cpus 2 --memory 4G --disk 20G --name $Name 24.04 --timeout 1200 --cloud-init $Url

4. Youe will see the follwing messages,
> <pre>Creating kind
> Configuring kind
> Staring kind
> Waiting for initialization to complete
> Launched: kind

5. Type the following command to get information on your new Hyper-V VM.
> multipass info kind

Output:<br>

><pre>Name:           kind
>State:          Running
>Snapshots:      0
>IPv4:           XXX.XXX.XXX.XXX
>                 172.17.0.1
>                 10.254.254.1
>...

6. Note down the first IP adderess XXX.XXX.XXX.XXX
7. Open you favorite SSH application, Putty/MobaXterm.
8. Connect to XXX.XXX.XXX.XXX
9. Login as `student` with password as `student`
10. In the VM, change directory to `~/Projects/kind`
11. Type the following command to stand up a multi node Kubernetes cluster.
> <pre>kind create cluster --config kind.yaml
12. Check your Kubernetes cluster
> <pre>kubectl cluster-info --context kind-kind
13. To destroy the VM type the following command.
> <pre>multipass stop kind
> multipass delete kind
> multipass purge
14. For more information on `multipass` command, please do read the documentation at https://canonical.com/multipass/docs
15. If you wan to customize the automation of this Hyper-V VM, `git clone` this repository, read Cloud-Init documentaiont at https://cloudinit.readthedocs.io/en/latest/index.html and start hacking.

### For Windows 10
1. If you are on Windows 10, you will not have access to Hyper-V. However, you still have WSL.
2. Enable WSL with instructions from https://learn.microsoft.com/en-us/windows/wsl/install\
3. It is highly recommanded for you to do the following steps in Windows Terminal Powershell. Follow the instruction at https://learn.microsoft.com/en-us/windows/terminal/install to instal Windows Terminal.
4. Create a new Folder on you Windows 10 file system.
5. In Powershell, change directory to your new Folder.
6. Download this file https://cloud-images.ubuntu.com/wsl/noble/current/ubuntu-noble-wsl-amd64-ubuntu.rootfs.tar.gz into your current Folder.
7. Download this file https://github.com/tsanghan/mcka/releases/latest/download/cloud-config-wsl.yaml
8. Copy the file `cloud-config-wsl.yaml` to `$HOME\.cloud-init\kind.user-data`
9. I fyou are in CMD, the destination file will be `%userprofile%\.cloud-init\kind.user-data`
10. Run the following command in Powershell,
> <pre>wsl --import kind .\kind ubuntu-noble-wsl-amd64-ubuntu.rootfs.tar.gz
11. You will see the message show below.
> <pre>Import in progress, this may take a few minutes.
> The operation completed successfully.
12. Next type the following command.
> <pre>wsl -d kind
13. You will be droped into a `BASH shell` as `root`.
14. Wait till you are kick off the `BASH shell` and back into `Powershell`.
15. Bakc at Powershell, they the following command.
> <pre>wsl -d kind -u student --cd ~
16. You are starting up your new WSL distribution and login as `student` and will will be place into `student`'s HOME directory.
17. In WSL, change directory to `~/Projects/kind`
18. Type the following command to stand up a multi node Kubernetes cluster.
> <pre>kind create cluster --config kind.yaml
19. Check your Kubernetes cluster
> <pre>kubectl cluster-info --context kind-kind
20. To exit BASH shell, type `Ctrl-d` to go back to `Powershell`
21. To destroy your WSL distribution.
> <pre>wsl --unregister kind
22. If you wan to customize the automation of this Hyper-V VM, `git clone` this repository, read Cloud-Init documentaiont at https://cloudinit.readthedocs.io/en/latest/index.html and start hacking.
