# mcka

### More Commonly Known As

#### (Multipass Cloud-Config KinD) &times; And

How to use the resources provided here to spin up a single local VM and stand up a multi node Kubernetes cluster for your self upskilling in 40 seconds.

### For Windows 10 Pro

1. If you have Windows 10 Pro, enable Hyper-V. Follow instructions at https://learn.microsoft.com/en-us/windows-server/virtualization/hyper-v/get-started/Install-Hyper-V?pivots=windows

2. Install `multipass`, please refer to https://canonical.com/multipass/install for instructions on your Operatting System.

3. Run the following command in Powershell.

> $Url = 'https://github.com/tsanghan/mcka/releases/latest/download/cloud-config-hyperv.yaml'<br>
> $Name = kind<br>
> multipass launch --cpus 2 --memory 4G --disk 20G --name $Name 24.04 --timeout 1200 --cloud-init $Url

4. Youe will see the follwing messages,
> Creating kind<br>
> Configuring kind<br>
> Staring kind<br>
> Waiting for initialization to complete<br>
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
> kind create cluster --config kind.yaml
12. Check your Kubernetes cluster
> kubectl cluster-info --context kind-kind
12. To destroy the VM type the following command.
> multipass stop kind<br>
> multipass delete kind<br>
> multipass purge
13. For more information on `multipass` command, please do read the documentation at https://canonical.com/multipass/docs
13. If you wan to customize the automation of the VM creation, `git clone` repository, read Cloud-Init documentaiont at https://cloudinit.readthedocs.io/en/latest/index.html and starting hacking.

### For Windows 10
1. If you are on Windows 10, you will not have access to Hyper-V. However, you still have WSL.
2. Enable WSL with instructions from https://learn.microsoft.com/en-us/windows/wsl/install\
3. It is highly recommanded for you to do the following steps in Windows Terminal Powershell. Follow the instruction at https://learn.microsoft.com/en-us/windows/terminal/install to instal Windows Terminal.
4. Create a new Folder on you Windows 10 file system.
5. In Powershell, change directory to your new Folder.
6. Download this file https://cloud-images.ubuntu.com/wsl/noble/current/ubuntu-noble-wsl-amd64-ubuntu.rootfs.tar.gz into your current Folder.
7. Run the following command in Powershell,
> wsl --import kind .\kind ubuntu-noble-wsl-amd64-ubuntu.rootfs.tar.gz
8. You will see the message show below.
> Import in progress, this may take a few minutes.<br>
> The operation completed successfully.
9. Next type the following command.
> wsl -d kind<br>
10. You will be droped into a `BASH shell` as `root`.
11. Wait till you are kick off the `BASH shell` and back into `Powershell`.
12. Bakc at Powershell, they the following command.
> wsl -d kind -u student --cd ~
13. You are starting up your new WSL distribution and login as `student` and will will be place into `student`'s HOME directory.
14. In WSL, change directory to `~/Projects/kind`
15. Type the following command to stand up a multi node Kubernetes cluster.
> kind create cluster --config kind.yaml
16. Check your Kubernetes cluster
> kubectl cluster-info --context kind-kind
17. To exit BASH shell, type `Ctrl-d` to go back to `Powershell`
18. To destroy your WSL distribution.
> wsl --unregister kind
