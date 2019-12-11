<h1>Introduction</h1>
This script can be used to generate RSA key pair, and modify /etc/ssh/sshd_config automatically for you.
After execution you'll be able to login server without password.

<h1>How to use</h1>
<h3>Download</h3>
Please execute the following command in your server.
<pre><code>
git clone https://github.com/junorz/sshgen.git ~/.sshgen
</code></pre>

<h3>Execute</h3>
<pre><code>
bash ~/.sshgen/gen.sh
</code></pre>

<h3>Configuration</h3>
<p>1.Please keep the file path by default（/root/.ssh/）.</p>
<p>2.Download the file named "id_rsa" after message "Now please download id_rsa file you have generated just now and press Enter" shows.</p>
<p><code>scp root@1.2.3.4:/root/.ssh/id_rsa ~/Documents/keys/id_rsa</code></p>
<p>3.Open a new ssh session with private key after message "Please try logging in with key file, if it succeed please enter Y" shows.</p>
<p><code>ssh root@1.2.3.4 -i ~/Documents/keys/id_rsa</code></p>
<p>4.If you login successfully, press y in the previous session window. The script will disable the password login by modifying the file /etc/ssh/sshd_config.</p>
<p>5.Please note that if you cannot login server successfully, press n or Ctrl+C to cancel the execution of script in the previous. Otherwise you will not be able to access your server anymore.</p>

<h1>How to login without password</h1>
<p>In MacOS, you can create(or append) the file in ~/.ssh/config like this:</p>
<pre><code>
Host linode1
Hostname 1.2.3.4
IdentityFile ~/Documents/keys/id_rsa
User root
</code></pre>
now you can login your server by typing "ssh linode1".

---

<h1>概述</h1>
此脚本可以在服务器上快速生成用于登录的公钥和私钥，并自动修改配置文件（/etc/ssh/sshd_config），达到禁用明文密码登录的效果，快速布置安全的服务器环境。

<h1>使用方法</h1>
<h3>下载脚本</h3>
<pre><code>
git clone https://github.com/junorz/sshgen.git ~/.sshgen
</code></pre>

<h3>运行</h3>
<pre><code>
bash ~/.sshgen/gen.sh
</code></pre>

<h3>配置</h3>
<p>1.你可以自己设定密钥的密码，但是保持生成的文件位置为默认（/root/.ssh/）。</p>
<p>2.出现“Now please download id_rsa file you have generated just now and press Enter”提示后请使用WinSCP等软件下载位于服务器/root/.ssh/位置的id_rsa文件。</p>
<p> 或者在本地命令行输入<code>scp root@1.2.3.4:/root/.ssh/id_rsa ~/Documents/keys/id_rsa</code>（示例）进行下载。</p>
<p>3.出现“Please try logging in with key file, if it succeed please enter Y”提示后请在本地新开一个命令行使用ssh连接，并尝试使用密钥文件登录。</p>
<p><code>ssh root@1.2.3.4 -i ~/Documents/keys/id_rsa</code>（示例）</p>
<p>4.如果登录成功，输入y确认，脚本会自动禁用明文密码登录，此后仅能使用私钥来登录服务器，所以请保管好私钥。</p>
<p>5.如果登录不成功，请输入n或Ctrl+C取消脚本的运行，否则你将会无法登录服务器。</p>

<h1>如何实现免密码登录</h1>
<p>以Mac系统为例子，你需要把在第3步登录时使用的私钥路径加入系统的<code>~/.ssh/config</code>中，你可能需要先<code>touch ~/.ssh/config</code>来建立这个文件。</p>
<p>假设私钥的地址是<code>~/Documents/keys/id_rsa</code>,那么config文件可以这么写:</p>
<pre><code>
Host linode1
Hostname 1.2.3.4
IdentityFile ~/Documents/keys/id_rsa
User root
</code></pre>
<p>以后管理VPS时只需要ssh root@linode1就可以自动登录了，是不是很方便？</p>
<p>如果你不想用别名，直接在Host段写IP，删除Hostname段就可以了。</p>

<h1>注意</h1>
请自行承担使用此脚本后带来的一切后果。
