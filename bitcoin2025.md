### **Step-by-Step Guide to Set Up a Bitcoin Core Node with Nginx**

---

### **1. Set Up Ubuntu Server**
- Ensure you have a fresh Ubuntu Server installation (e.g., Ubuntu 22.04 LTS).
- Update the system:
  ```bash
  sudo apt update && sudo apt upgrade -y
  ```

---

### **2. Download and Install Bitcoin Core**
- Download the latest stable version of Bitcoin Core. Replace `27.0` with the latest version if necessary:
  ```bash
  wget https://bitcoin.org/bin/bitcoin-core-27.0/bitcoin-27.0-x86_64-linux-gnu.tar.gz
  ```
- Extract the tarball:
  ```bash
  tar -xzf bitcoin-27.0-x86_64-linux-gnu.tar.gz
  ```
- Copy the binaries to `/usr/local/bin`:
  ```bash
  sudo cp bitcoin-27.0/bin/* /usr/local/bin/
  ```

---

### **3. Configure and Run Bitcoin Core**
- Start Bitcoin Core for the first time to generate the data directory:
  ```bash
  bitcoind -daemon
  ```
- Stop the server after a few seconds:
  ```bash
  bitcoin-cli stop
  ```
- Create a `bitcoin.conf` file in the `.bitcoin` directory (e.g., `/home/username/.bitcoin/bitcoin.conf`) with the following content:
  ```ini
  # Data Directory
  datadir=/home/username/.bitcoin

  # Prune old blocks to save disk space (prune to 25GB)
  prune=25000

  # Network Settings
  server=1
  listen=1
  port=8333
  rpcport=8332
  rpcbind=127.0.0.1
  rpcallowip=127.0.0.1

  # RPC Authentication (generate using `bitcoin-cli rpcauth`)
  rpcuser=RPCUSERNAME
  rpcpassword=RPCPASSWORD

  # Connection and Security
  maxconnections=40
  maxuploadtarget=5000
  bind=0.0.0.0
  externalip=YOUR_EXTERNAL_IP

  # Logging
  logtimestamps=1
  debug=rpc

  # Memory Optimization
  dbcache=150
  maxmempool=100
  mempoolexpiry=72

  # Fee Settings
  mintxfee=0.00001
  minrelaytxfee=0.00001
  fallbackfee=0.0001

  # Prune settings for a small node
  persistmempool=1
  blocksonly=1
  disablewallet=0
  ```
- Restart the Bitcoin Core node:
  ```bash
  bitcoind -daemon
  ```

---

### **4. Install Apache2 Utils and Create Basic Authentication**
- Install Apache2 Utils:
  ```bash
  sudo apt install apache2-utils -y
  ```
- Create a `.htpasswd` file for Nginx authentication:
  ```bash
  sudo htpasswd -c /etc/nginx/.htpasswd username
  ```
  (Replace `username` with your desired username and set a secure password.)

---

### **5. Install Nginx and Certbot**
- Install Nginx and Certbot:
  ```bash
  sudo apt update && sudo apt install nginx certbot python3-certbot-nginx -y
  ```
- Point your domain to the server’s IP address using your DNS provider.

---

### **6. Configure Nginx**
- Create an Nginx configuration file for your domain:
  ```bash
  sudo nano /etc/nginx/sites-available/domain.com.conf
  ```
- Add the following configuration:
  ```nginx
  limit_req_zone $binary_remote_addr zone=rpc_limit:10m rate=5r/s;

  server {
      server_name domain.com;

      add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

      access_log /var/log/nginx/explorer.access.log;
      error_log /var/log/nginx/explorer.error.log;

      allow IP1;
      allow IP2;
      allow IP3;
      deny all;

      location / {
          limit_req zone=rpc_limit burst=10 nodelay;

          auth_basic "Restricted Area";
          auth_basic_user_file /etc/nginx/.htpasswd;

          proxy_set_header Authorization "Basic BASE64_ENCODED_RPC_CREDENTIALS";
          proxy_pass http://127.0.0.1:8332;
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_http_version 1.1;
          proxy_set_header Connection "Keep-Alive";
          proxy_set_header Proxy-Connection "Keep-Alive";
      }
  }
  ```
  Replace `BASE64_ENCODED_RPC_CREDENTIALS` with the output of:
  ```bash
  echo -n "RPCUSERNAME:RPCPASSWORD" | base64
  ```
- Enable the configuration:
  ```bash
  sudo ln -s /etc/nginx/sites-available/domain.com.conf /etc/nginx/sites-enabled/
  ```
- Test the Nginx configuration:
  ```bash
  sudo nginx -t
  ```
- Reload Nginx:
  ```bash
  sudo systemctl reload nginx
  ```

---

### **7. Secure with SSL**
- Run Certbot to obtain an SSL certificate:
  ```bash
  sudo certbot --nginx
  ```
- Follow the prompts to complete the SSL setup.

---

### **8. Test the Setup**
- From an allowed IP, test the RPC endpoint:
  ```bash
  curl --user username:Password123! -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"getblockchaininfo","params":[],"id":1}' https://domain.com
  ```

---

### **9. Implement UFW and Other Security Measures**
- Install and configure UFW:
  ```bash
  sudo apt install ufw -y
  sudo ufw allow ssh
  sudo ufw allow 8333/tcp
  sudo ufw allow 80/tcp
  sudo ufw allow 443/tcp
  sudo ufw enable
  ```
- Consider additional security measures:
  - Use SSH key-based authentication.
  - Disable root login.
  - Set up fail2ban to prevent brute-force attacks.

---

### **10. Document the Process**
- Create a `.md` file to document the setup process for future reference or to share with others. Include:
  - Steps taken.
  - Commands used.
  - Configuration files.
  - Troubleshooting tips.

---

### **Potential Improvements**
1. **Automate Backups**: Set up regular backups of the `.bitcoin` directory.
2. **Monitoring**: Use tools like Prometheus and Grafana to monitor node performance.
3. **High Availability**: Consider setting up a redundant node for failover.
4. **Rate Limiting**: Fine-tune Nginx rate limiting to prevent abuse.

---

### **Common Issues and Fixes**
- **RPC Authentication Failure**: Double-check the `rpcuser` and `rpcpassword` in `bitcoin.conf`.
- **Nginx 403 Forbidden**: Ensure the `.htpasswd` file permissions are correct.
- **SSL Errors**: Verify the domain is correctly pointed to the server’s IP.



