read -p "Add User [frappe-user] : " bench_user &&
bench_user=${bench_user:-frappe-user} &&

echo $' \n Adding user \n ' &&
sudo adduser $bench_user && 
usermod -aG sudo $bench_user &&
su $bench_user &&
cd /home/$bench_user
