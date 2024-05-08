<p align="center">
<picture>
<img width="160" height="160"  alt="XPanel" src="https://github.com/iPmartNetwork/iPmart-SSH/blob/main/images/logo.png">
</picture>
  </p> 
<p align="center">
<h1 align="center"/>Easy-3XUI</h1>
<h6 align="center">Easy Install 3xui<h6>
</p>





# Install

```
bash <(curl -Ls https://raw.githubusercontent.com/iPmartNetwork/Easy-3XUI/main/easy.sh)
```

if you are installing v2ray from scratch
you can use these steps (recomended):

- Set domains
- Install Nginx and get certs
- Install 3X-UI panel
- From x-ui install Geo, BBR, fail2ban(if you want, up to you)
- Allow Ports you need using ufw
- You can use the the ssl you got for your domain in your panel, for that you can use the command below to find the path

```
sudo certbot certificates
```

7. Install Warp (more details below)
8. Done

# Warp

for Warp you have the options to choose 3x-ui script from the panel itself
or you can use the one provided here made by hamid-gh98
if you use hamid-gh98 from my script add the json code below to your v2ray panel
https://yourdomain:port/panel/settings --> Xray Configuration --> Advanced Template

```
{
        "type": "field",
        "outboundTag": "WARP",
        "domain": [
          "regexp:.*"
        ],
        "ip": [
          "0.0.0.0/0"
        ]
      }
```

after the installation you can use the option

```
warp a
```

to change to warp plus (you can easily get warp plus key from telegram Bots or any other way possible on the internet)


# تلگرام

[@ipmart_network](https://t.me/ipmart_network)

[@iPmart Group](https://t.me/ipmartnetwork_gp)




 # حمایت از ما :hearts:
حمایت های شما برای ما دلگرمی بزرگی است<br> 
<p align="left">
<a href="https://plisio.net/donate/kB7QU7f7" target="_blank"><img src="https://plisio.net/img/donate/donate_light_icons_mono.png" alt="Donate Crypto on Plisio" width="240" height="80" /></a><br>
	
|                    TRX                   |                       BNB                         |                    Litecoin                       |
| ---------------------------------------- |:-------------------------------------------------:| -------------------------------------------------:|
| ```TJbTYV1fFo2485sYMyajxGPLFzxmNmPrNA``` |  ```0x4af3de9b303a8d43105e284823d95b4c600961a3``` | ```MPrkzFiNtw4Rg67bbZB6gCxa9LV87orABM``` |	

</p>	




<p align="center">
<picture>
<img width="160" height="160"  alt="XPanel" src="https://github.com/iPmartNetwork/iPmart-SSH/blob/main/images/logo.png">
</picture>
  </p> 
