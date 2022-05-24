#! /bin/bash
echo "script started">>result_summary
URL="https://common-tools-eu-nl.obs.eu-nl.otc.t-systems.com/gitlab-runner-openbsd-amd64"
URL1="https://common-tools.obs.eu-de.otc.t-systems.com/gitlab-runner-openbsd-amd64"
URL2="http://ftp.fau.de/centos/7.9.2009/updates/x86_6"
URL3="http://ftp.fau.de/centos/7.9.2009/updates/x86_64/Packages/bash-4.2.46-35.el7_9.x86_64.rpm"
echo `dig common-tools-eu-nl.obs.eu-nl.otc.t-systems.com +short`

echo $URL>>result_summary
echo `date`>>result_summary
sudo sed -i '/options edns0 trust-ad/d' /etc/resolv.conf
sudo sed -i '/search openstacklocal/d' /etc/resolv.conf
sudo sed -i 's/nameserver 127.0.0.53/nameserver 8.8.8.8/g' /etc/resolv.conf

success=0
un_success=0
for j in {1..100}
    do
            dig common-tools.obs.eu-de.otc.t-systems.com +short
            echo `netstat -ano | grep 100.*:443` >> result_detail
            echo `netstat -ano | grep 80.158.*:443` >> result_detail
            echo "start download" >>result_detail
            #if ! curl -L --retry-delay 5 --retry 3 "$URL3" -o download.file
            if ! curl -L --retry-delay 1 --retry 2 "$URL1" -o download.file
            then
            echo "download unsecessful" >> result_b

            un_success=$((un_success + 1))
            else
            echo "download successful" >> result_b
            success=$((success + 1))
            echo `netstat -ano | grep 80.158.*:443` >> result_detail
            echo "\n" >>result_detail
            echo `netstat -ano | grep 100.*:443` >> result_detail
            echo "\n" >>result_detail
            fi

    done
echo `date`>>longtermtestresult
echo "successful requests" >>longtermtestresult
echo $success >>longtermtestresult
echo "unsuccessful requests" >>longtermtestresult
echo $un_success >>longtermtestresult

