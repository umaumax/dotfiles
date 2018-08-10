def parse_env(val):
    import subprocess
    p = subprocess.Popen('echo "' + val + '"', stdout=subprocess.PIPE, shell=True)
    return p.stdout.readline().rstrip().decode('utf-8')
