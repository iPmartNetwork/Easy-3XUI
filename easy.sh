#!/bin/bash

red='\033[0;31m'
blue="\e[36m\e[01m"
bblue='\033[0;34m'
yellow='\033[0;33m'
bYellow="\e[1;33m"
green='\033[0;32m'
plain='\033[0m'
red() { echo -e "\033[31m\033[01m$1\033[0m"; }
green() { echo -e "\033[32m\033[01m$1\033[0m"; }
yellow() { echo -e "\033[33m\033[01m$1\033[0m"; }
blue() { echo -e "\033[36m\033[01m$1\033[0m"; }
white() { echo -e "\033[37m\033[01m$1\033[0m"; }
bblue() { echo -e "\033[34m\033[01m$1\033[0m"; }
rred() { echo -e "\033[35m\033[01m$1\033[0m"; }
readtp() { read -t5 -n26 -p "$(yellow "$1")" $2; }
readp() { read -p "$(yellow "$1")" $2; }

if ! command -v qrencode &>/dev/null || ! command -v jq &>/dev/null || ! dpkg -l | grep -q net-tools; then
    sudo apt-get update
    if ! command -v qrencode &>/dev/null; then
        rred "qrencode is not installed. Installing..."
        sudo apt-get install qrencode -y

        # Check if installation was successful
        if [ $? -eq 0 ]; then
            red "qrencode is now installed."
        else
            red "Error: Failed to install qrencode."
        fi
    else
        green "qrencode is already installed."
    fi

    if ! command -v jq &>/dev/null; then
        rred "Installing jq..."
        if sudo apt-get install jq -y; then
            red "jq installed successfully."
        else
            red "Error: Failed to install jq."
            exit 1
        fi
    else
        green "jq is already installed."
    fi

    if ! dpkg -l | grep -q net-tools; then
        rred "net-tools is not installed. Installing..."
        sudo apt-get install net-tools -y

        # Check if installation was successful
        if [ $? -eq 0 ]; then
            red "net-tools is now installed."
        else
            red "Error: Failed to install net-tools."
            exit 1
        fi
    else
        green "net-tools is already installed."
    fi
else
    green "qrencode, jq, and net-tools are already installed."
fi

display_main_menu() {
    clear
    echo
    echo
    echo "
    ____________________________________________________________________________________
           ____                             _     _                                     
       ,   /    )                           /|   /                                  /   
    -------/____/---_--_----__---)__--_/_---/-| -/-----__--_/_-----------__---)__---/-__-
      /   /        / /  ) /   ) /   ) /    /  | /    /___) /   | /| /  /   ) /   ) /(    
    _/___/________/_/__/_(___(_/_____(_ __/___|/____(___ _(_ __|/_|/__(___/_/_____/___\__
                                                                                     
    "
    echo "***** https://github.com/ipmartnetwork *****"
    yellow "--------------------Tools-----------------------------"
    green "1. Set Domains    2. Install 3x-ui Panel"
    echo
    green "3. Warp"
    echo
    rred "0. Exit"
    echo "------------------------------------------------------"
}

display_domains_menu() {
    clear
    echo "**********************************************"
    green "1. IPv4 Domain"
    echo
    green "2. IPv6 Domain"
    echo
    green "3. Cert + Nginx Setup"
    echo
    green "4. NAT Nginx Setup (get certs manually from Cloudflare)"
    echo
    green "0. Back to Main Menu"
    echo "**********************************************"
    echo -e "${plain}IPv4 Domain:${red} $IPV4_DOMAIN${plain}"
    echo -e "${plain}IPv6 Domain:${red} $IPV6_DOMAIN${plain}"
    echo "**********************************************"
}

display_install_panel_menu() {
    clear
    echo "**********************************************"
    green "1. X-UI iPmart"
    green "0. Back to Main Menu"
    echo "**********************************************"
}

install_x_ui_sanaei() {
    clear
    echo "Installing X-UI iPmart..."
    sleep 2
    bash <(curl -Ls https://raw.githubusercontent.com/iPmartNetwork/3x-ui/main/install.sh)
    readp "Press Enter to continue..."
}

display_warp_menu() {
    clear
    echo "**********************************************"
    green "1. Install"
    green "0. Back to Main Menu"
    echo "**********************************************"
}

install_warp() {
    echo "Installing Warp..."
    bash <(curl -sSL https://raw.githubusercontent.com/hamid-gh98/x-ui-scripts/main/install_warp_proxy.sh)
    readp "Press Enter to continue..."
}

# domain codes

setup_ipv4_domain() {
    if [ -z "$IPV4_DOMAIN" ]; then
        rred "IPV4_DOMAIN is not set."
        echo "Please enter the new domain:"
        read -r DOMAIN
        export IPV4_DOMAIN=$DOMAIN
        if grep -q "export IPV4_DOMAIN" ~/.bashrc; then
            echo "IPV4_DOMAIN is set in ~/.bashrc. Updating the value..."
            sed -i "s/export IPV4_DOMAIN=.*/export IPV4_DOMAIN=$DOMAIN/" ~/.bashrc
            source ~/.bashrc
        else
            echo "IPV4_DOMAIN is not set in ~/.bashrc. Adding the export command..."
            echo -e "export IPV4_DOMAIN=$DOMAIN" >>~/.bashrc
            source ~/.bashrc
        fi
        echo -e "IPV4_DOMAIN updated to:${yellow} $IPV4_DOMAIN${plain}"
    else
        echo "Current value of IPV4_DOMAIN is: $DOMAIN"
        read -p "Do you want to change the domain? (y/n): " choice
        if [[ $choice =~ ^[Yy] ]]; then
            echo "Please enter the new domain:"
            read -r DOMAIN
            export IPV4_DOMAIN=$DOMAIN
            sed -i "s/export IPV4_DOMAIN=.*/export IPV4_DOMAIN=$IPV4_DOMAIN/" ~/.bashrc
            source ~/.bashrc
            echo -e "IPV4_DOMAIN updated to:${yellow} $IPV4_DOMAIN${plain}"
        else
            echo "IPV4_DOMAIN remains unchanged."
        fi
    fi
    readp "Press Enter to continue..."

}

setup_ipv6_domain() {
    if [ -z "$IPV6_DOMAIN" ]; then
        rred "IPV6_DOMAIN is not set."
        echo "Please enter the new domain:"
        read -r DOMAIN
        export IPV6_DOMAIN=$DOMAIN
        if grep -q "export IPV6_DOMAIN" ~/.bashrc; then
            echo "IPV6_DOMAIN is set in ~/.bashrc. Updating the value..."
            sed -i "s/export IPV6_DOMAIN=.*/export IPV6_DOMAIN=$DOMAIN/" ~/.bashrc
            source ~/.bashrc
        else
            echo "IPV6_DOMAIN is not set in ~/.bashrc. Adding the export command..."
            echo -e "export IPV6_DOMAIN=$DOMAIN" >>~/.bashrc
            source ~/.bashrc
        fi
        echo -e "IPV6_DOMAIN updated to:${yellow} $IPV6_DOMAIN${plain}"
    else
        echo "Current value of IPV6_DOMAIN is: $DOMAIN"
        read -p "Do you want to change the domain? (y/n): " choice
        if [[ $choice =~ ^[Yy] ]]; then
            echo "Please enter the new domain:"
            read -r DOMAIN
            export IPV6_DOMAIN=$DOMAIN
            sed -i "s/export IPV6_DOMAIN=.*/export IPV6_DOMAIN=$IPV6_DOMAIN/" ~/.bashrc
            source ~/.bashrc
            echo -e "IPV6_DOMAIN updated to:${yellow} $IPV6_DOMAIN${plain}"
        else
            echo "IPV6_DOMAIN remains unchanged."
        fi
    fi
    readp "Press Enter to continue..."
}

setup_cert() {
    if [ -z "$IPV4_DOMAIN" ]; then
        rred "IPv4 Domain is not set. Please set it first using option 1 in Domains menu."
        return
    else
        source ~/.bashrc
        # Install Certbot
        sudo apt-get update
        clear
        yellow "Installing Certbot..."
        sudo apt-get install -y certbot python3-certbot-nginx
        sudo apt install ufw -y
        sudo ufw enable
        sudo ufw allow ssh

        # Ensure Nginx is installed and set up
        if ! command -v nginx &>/dev/null; then
            sudo apt-get install -y nginx
            sudo systemctl enable nginx
            echo "Nginx installed."
            sleep 2
        fi

        sudo ufw allow 'Nginx HTTPS'
        sudo ufw allow 'Nginx HTTP'

        # Prompt user for HTTPS port
        clear

        sudo systemctl stop nginx

        readp "Enter your email: " email
        # Request SSL certificate using Certbot and specify the chosen port
        sudo certbot certonly --standalone --preferred-challenges http --agree-tos --email "$email" -d "$IPV4_DOMAIN"

        sudo ufw delete allow 'Nginx HTTP'

        sudo systemctl start nginx

        your_domain="$IPV4_DOMAIN"

        sudo mkdir -p /var/www/$your_domain/html

        html_content=$(
            cat <<EOF
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <script src="https://cdn.jsdelivr.net/particles.js/2.0.0/particles.min.js"></script>
            <title>Welcome Page</title>
            <style>
                            body {
                    margin: 0;
                    overflow: hidden;
                    font-family: Arial, sans-serif;
                }

                #welcome-page {
                    position: relative;
                    height: 100vh;
                    width: 100%;
                    overflow: hidden;
                }

                #welcome-content {
                    position: absolute;
                    top: 50%;
                    left: 50%;
                    transform: translate(-50%, -50%);
                    text-align: center;
                    color: #fff;
                    z-index: 2; /* Place above particle background */
                }

                #enter-button {
                    background-color: #007bff;
                    color: #fff;
                    border: none;
                    padding: 10px 20px;
                    font-size: 16px;
                    cursor: pointer;
                    border-radius: 5px;
                    transition: background-color 0.3s ease;
                }

                #enter-button:hover {
                    background-color: #0056b3;
                }

                /* Particle Container */
                #particles-js {
                    position: fixed;
                    width: 100%;
                    height: 100%;
                    background-color: #000000; /* Set background color for particles */
                    z-index: 1; /* Place behind content */
                }
                body > div > div {
                    top: 50%;
                    left: 50%;
                    transform: translate(-50%, -50%);
                    position: absolute;
                    text-align: center;
                    color: #fff;
                    z-index: 2;
                }
            </style>
        </head>

        <body>
            <div id="particles-js">
                <div class="welcome-content">
                    <h1>Welcome</h1>
                    <p>Click to enter</p>
                    <button id="enter-button">...</button>
                </div>
            </div>
        <script>
                    particlesJS("particles-js", {
            particles: {
                number: { value: 80, density: { enable: true, value_area: 800 } },
                color: { value: "#ffffff" },
                shape: {
                    type: "circle",
                    stroke: { width: 0, color: "#000000" },
                    polygon: { nb_sides: 5 },
                    image: { src: "img/github.svg", width: 100, height: 100 },
                },
                opacity: {
                    value: 0.5,
                    random: false,
                    anim: { enable: false, speed: 1, opacity_min: 0.1, sync: false },
                },
                size: {
                    value: 3,
                    random: true,
                    anim: { enable: false, speed: 40, size_min: 0.1, sync: false },
                },
                line_linked: {
                    enable: true,
                    distance: 150,
                    color: "#ffffff",
                    opacity: 0.4,
                    width: 1,
                },
                move: {
                    enable: true,
                    speed: 6,
                    direction: "none",
                    random: false,
                    straight: false,
                    out_mode: "out",
                    bounce: false,
                    attract: { enable: false, rotateX: 600, rotateY: 1200 },
                },
            },
            interactivity: {
                detect_on: "canvas",
                events: {
                    onhover: { enable: true, mode: "repulse" },
                    onclick: { enable: true, mode: "push" },
                    resize: true,
                },
                modes: {
                    grab: { distance: 400, line_linked: { opacity: 1 } },
                    bubble: { distance: 400, size: 40, duration: 2, opacity: 8, speed: 3 },
                    repulse: { distance: 200, duration: 0.4 },
                    push: { particles_nb: 4 },
                    remove: { particles_nb: 2 },
                },
            },
            retina_detect: true,
        });
        const enterButton = document.getElementById("enter-button");

        enterButton.addEventListener("click", function() {
            window.location.href = "https://sourceforge.net";
        });
            </script>
        </body>
        </html>
EOF
        )

        echo "$html_content" | sudo tee /var/www/$your_domain/html/index.html >/dev/null

        nginx_conf=$(
            cat <<EOF
        server {
        listen 443 ssl;
        listen [::]:443 ssl;

        server_name $your_domain;
        ssl_certificate /etc/letsencrypt/live/$your_domain/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/$your_domain/privkey.pem;
        
        root /var/www/$your_domain/html;
        index index.html index.htm;
        }

EOF
        )

        # Write Nginx server block configuration to file
        echo "$nginx_conf" | sudo tee /etc/nginx/sites-available/$your_domain >/dev/null

        # Enable the Nginx server block
        sudo ln -s /etc/nginx/sites-available/$your_domain /etc/nginx/sites-enabled/

        # Test the Nginx configuration and restart Nginx
        # sudo mv /etc/nginx/sites-enabled/default /etc/nginx/sites-enabled/default_disabled
        sudo service apache2 stop
        sudo nginx -t
        sudo systemctl restart nginx
        sudo nginx -s reload

        green "Nginx configured to use HTTPS for $IPV4_DOMAIN."
    fi
    readp "Press Enter to continue..."
}

setup_nginx_nat() {
    if [ -z "$IPV4_DOMAIN" ] && [ ! -f "/etc/letsencrypt/live/$IPV4_DOMAIN/fullchain.pem" ]; then
        rred "IPv4 Domain is not set. Please set it first using option 1 in Domains menu."
        echo
        yellow "Please get the certificate and key from Cloudflare and use the commands below: "
        echo
        white "Command for certficate: "
        yellow "nano /etc/letsencrypt/live/$your_domain/fullchain.pem"
        echo
        white "Command for Key: "
        yellow "nano /etc/letsencrypt/live/$your_domain/privkey.pem"
        echo
        readp "Press Enter to continue..."
        return
    else
        source ~/.bashrc
        sudo apt-get update
        clear
        sudo apt install ufw -y
        sudo ufw enable
        sudo ufw allow ssh

        sudo apt-get install -y nginx

        # Ensure Nginx is installed and set up
        if ! command -v nginx &>/dev/null; then
            sudo systemctl enable nginx
            echo "Nginx installed."
            sleep 2
        fi

        clear

        # Prompt user for HTTPS port
        your_domain="$IPV4_DOMAIN"

        sudo mkdir -p /etc/letsencrypt/live/$your_domain

        sudo systemctl start nginx

        readp "Please Enter the port number: " port

        sudo ufw allow 'Nginx HTTPS'

        sudo mkdir -p /var/www/$your_domain/html

        html_content=$(
            cat <<EOF
        <html><head>
        <style>
            .banner {
                text-align: center;
                padding: 5px;
                font-size: 169px;
                color: lightblue;
                padding-bottom: 0;
            }
            .created-by {
                text-align: center;
                color: lightblue;
                font-size: 18px;
                margin-bottom: 40px;
            }
            .link {
            display: block;
            color: gold;
            text-align: center;
            font-size: 18px;
            margin-top: 10px;
            text-decoration: none;
            }
            .link:hover {
            text-decoration: underline;
            }
        </style>
        </head>
        <body style="
            background-color: #03031f;
        ">
        <div class="banner">
            AIO
        </div>
        <div class="created-by">
            Created by Hosy
        </div>
        <a href="https://github.com/iPmartNetwork" class="link" target="_blank">
            Github: github.com/iPmartNetwork
        </a>
        <a href="https://twitter.com/iPmartNetwork" class="link" target="_blank">
            Twitter: twitter.com/iPmartNetwork
        </a>


        </body></html>
EOF
        )

        echo "$html_content" | sudo tee /var/www/$your_domain/html/index.html >/dev/null

        nginx_conf=$(
            cat <<EOF
server {
    listen $port ssl;
    listen [::]:$port ssl;

    server_name $your_domain;
    ssl_certificate /etc/letsencrypt/live/$your_domain/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$your_domain/privkey.pem;
    
    root /var/www/$your_domain/html;
    index index.html index.htm;
}
EOF
        )

        # Write Nginx server block configuration to file
        echo "$nginx_conf" | sudo tee /etc/nginx/sites-available/$your_domain >/dev/null

        # Enable the Nginx server block
        sudo ln -s /etc/nginx/sites-available/$your_domain /etc/nginx/sites-enabled/

        # Test the Nginx configuration and restart Nginx
        sudo mv /etc/nginx/sites-enabled/default /etc/nginx/sites-enabled/default_disabled
        sudo service apache2 stop
        sudo nginx -t
        sudo systemctl restart nginx
        sudo nginx -s reload

        green "Nginx configured to use HTTPS for $IPV4_DOMAIN."
    fi
    readp "Press Enter to continue..."
}

# menu bullshit

while true; do
    display_main_menu
    readp "Enter your choice: " main_choice

    case "$main_choice" in
    3) # Warp
        while true; do
            display_warp_menu
            readp "Enter your choice: " warp_choice

            case "$warp_choice" in
            1) # Install
                install_warp
                ;;
            0) # Back to Main Menu
                break
                ;;
            *)
                echo
                echo "Invalid choice. Please select a valid option!"
                readp "Press enter to select again..."
                ;;
            esac
        done
        ;;
    2) # Install Panel
        while true; do
            display_install_panel_menu
            readp "Enter your choice: " install_panel_choice

            case "$install_panel_choice" in
            1) # X-UI Sanaei
                install_x_ui_sanaei
                ;;
            0) # Back to Main Menu
                break
                ;;
            *)
                echo
                echo "Invalid choice. Please select a valid option!"
                readp "Press enter to select again..."
                ;;
            esac
        done
        ;;
    1) # Domains
        while true; do
            display_domains_menu
            readp "Enter your choice: " domains_choice
            case "$domains_choice" in
            1) # IPv4 Domain
                setup_ipv4_domain
                ;;
            2) # IPv6 Domain
                setup_ipv6_domain
                ;;
            3) # Cert + nginx setup
                setup_cert
                ;;
            4) # NAT nginx setup
                setup_nginx_nat
                ;;
            0) # Back to Main Menu
                break
                ;;
            *)
                echo
                echo "Invalid choice. Please select a valid option!"
                readp "Press enter to select again..."
                ;;
            esac
        done
        ;;
    0) # Exit
        clear
        echo "Exiting..."
        exit
        ;;
    *)
        echo
        echo "Invalid choice. Please select a valid option!"
        readp "Press enter to select again..."
        ;;
    esac
done
