# brmangler

   
   ██████╗ ██████╗    ███╗   ███╗ █████╗ ███╗   ██╗ ██████╗ ██╗     ███████╗██████╗ 
   ██╔══██╗██╔══██╗   ████╗ ████║██╔══██╗████╗  ██║██╔════╝ ██║     ██╔════╝██╔══██╗
   ██████╔╝██████╔╝   ██╔████╔██║███████║██╔██╗ ██║██║  ███╗██║     █████╗  ██████╔╝
   ██╔══██╗██╔══██╗   ██║╚██╔╝██║██╔══██║██║╚██╗██║██║   ██║██║     ██╔══╝  ██╔══██╗
   ██████╔╝██║  ██║██╗██║ ╚═╝ ██║██║  ██║██║ ╚████║╚██████╔╝███████╗███████╗██║  ██║
   ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝
         Brazilian wordlist generator hu3hu3hu3  
         
          Usage: ./brmangler.rb [options]

    -f, --file /path/to/file         *Mandatory* File with names
    -m, --min 8                      Minimun password size
    -M, --Max 12                     Mximun password size
    -l, --leet                       DISABLE leetSpeak outputs (e.g. "p@55w0rd")
    -c, --capitalize                 DISABLE capitalized outputs (e.g. "Password")
    -q, --qt                         Calculate the quantity of outputs
    -u, --upcase                     DISABLE uppercase
    -d, --date                       DISABLE dates (e.g. "password@020212")
    -s, --special                    DISABLE passwords with special characters
    -t, --twoletters                 Enable two letters passwords (e.g. "af212303")
    -i, --insane                     Use *ALL* wordlists to create passwords

