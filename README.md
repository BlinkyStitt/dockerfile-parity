https://parity.io/

https://ethereum.org/

Example docker-compose.yml for a fast client:

    version: '3'

    volumes:
      parity_data:

    services:
      parity:
        image: bwstitt/parity
        restart: always
        ports:
          # - "127.0.0.1:5001:5001/tcp"  # ipfs
          - "127.0.0.1:8545:8545/tcp"  # rpc
          - "127.0.0.1:8546:8546/tcp"  # websockets
          - "127.0.0.1:8180:8180/tcp"  # ui
          - "30303:30303/tcp"  # p2p
          - "30303:30303/udp"  # p2p discovery
        command:
          --mode passive
          --pruning fast
          --jsonrpc-interface all
          --jsonrpc-hosts localhost:8545
          --ui-interface all
          --ui-hosts localhost:8180
          --ws-interface all
          --ws-hosts localhost:8546
          --ws-origins chrome-extension://*,moz-extension://*,localhost:8180
        volumes:
          - parity_data:/home/abc/.local/share/io.parity.ethereum/

Then run:

    docker-compose up -d

Watch logs:

    docker-compose logs --tail 10 -f

Open the UI:

    open http://localhost:8180
