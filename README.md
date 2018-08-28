# Battleship

A solidity implementation of the classic board game Battleship

* [Battleship](https://en.wikipedia.org/wiki/Battleship_(game)) - The original specification for the game

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### IMPORTANT NOTE

I did not have time to complete all the requirements for this project as I don't have any web development experience, specifically the front-end UI or the Lobby solidity requirement.

I have a very basic front-end which implements web3 using MetaMask and the functions registerPlayer(string) and returnPlayers()
can be used on the UI to register and get the player names.

The actual game functionality does work and can be tested in Remix by making manual calls to the functions.

Eg.

Step 1: registerPlayer - "Chris"
Step 2: registerPlayer - "Russ"
Step 3: placeShip (6 times) - 
0,0,"FRIGATE","Chris",0
0,1,"SUBMARINE","Chris",0
0,2,"DESTROYER","Chris",0
0,0,"FRIGATE","Russ",0
0,1,"SUBMARINE","Russ",0
0,2,"DESTROYER","Russ",0
Step 4: fireShot - 0,0
Step 5: Repeat Step 4 until winner is found.

I have been using Firefox recently as for some reason, Chrome seems to be adding an extra "(" when parsing the ABI code assignment in battleship.js.

I have also been unable to implement any tests, I'm still working on this but keep getting various errors. Current error is "ParserError: Expected primary expression.".

### Prerequisites

This project requires VirtualBox (or similar VM provider), Ubuntu, node.js, Solidity compiler (solc-js), Truffle framework, ganache-cli and a local webserver, here I am using node.js http-server.

```
VirtualBox 5.2.16
Ubuntu 16.04 (xenial)
Node.js 10.4.1
Solidity 0.4.24
Truffle 4.1.13
Ganache CLI 6.1.6
http-server 0.11.1
```

### Installing

The following steps detail how to get up and running with a development environment using the above stack.

__***Ubuntu 16.04 LTS 64-bit in VirtualBox 5.0.32***__

Open a terminal and type:

```
sudo apt update && sudo apt upgrade -y
sudo apt install build-essential
reboot
```

__***Install Virtualbox Guest Additions***__

This can be done from the drop down menu in VirtualBox, then open a terminal window, as root:

```
usermod -a -G vboxsf *username*
reboot
```

__***Install node.js and npm***__

Obtain current version of npm and nodejs from * [https://nodejs.org/en/download/current/].

Copy over the downloaded package from your host to the VM using a share between the host and the VM.

Note: The __make__ could take some time depending on system resources.

```
cd ~/Downloads
tar zxvf node-v7.7.3.tar.gz node-v7.7.3
cd node-v7.7.3
sudo ./configure && sudo make && sudo make install
reboot
```
__***Install solc.js***__

```
sudo npm install -g solc
```

__***Install Truffle***__

```
sudo npm install -g truffle
```

__***Install ganache-cli***__

```
sudo npm install -g ganache-cli
```

__***Install http-server***__

```
sudo npm install -g http-server
```

__***Install the code***__

Download the zipped code tree from GitHub at https://github.com/chris-bluemoon/Battleships

Then make a new project directory and unzip:

```
cd ~ && unzip ~/Downloads/Battleships-master.zip
```

__***Start the http-server***__

Open a new terminal then start a local webserver on the default port of 8080:

```
cd ~/Battleship-master/src && http-webserver
```

__***Start ganache-cli***__

Open a new terminal then start a local personal Ethereum network:

```
ganache-cli
```

__***Configure the local Ethereum dev server***__

Remove truffle-config.js (used only for Windows) and edit truffle.js to include:

```
module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      gas: 6700000,
      network_id: "*" // Match any network id
    }
  }
};
```

__***Compile and migrate the Solidity contracts***__

Ensure your pwd is within the Truffle project structure:

```
truffle compile
truffle migrate --reset
````

__***Install MetaMask on the Chrome browser***__make__

Once the extension is installed, open MetaMask and "Restore from seed phrase" to connect to the Ganache network that was started earlier. The seed words will be found in the output logs after Ganache starts.

__***Launch a browser and open the game***__

Using Chrome, visit:

http://127.0.0.1:8080

End with an example of getting some data out of the system or using it for a little demo

## Running the tests

To run the Solidity contract test, simply cd to the contract home and:

```
truffle test
```

The test scripts are written in Solidity and can be found in the __test__ directory under the project home.

### Break down into end to end tests

Test 1:

Explanation

Test 2:

Explanation

Test 3:

Explanation

Test 4:

Explanation

Test 5:

Explanation

## Versioning

Version 1.0

## Authors

* **Chris Milner** - *Initial work* - [Chris Milner](https://github.com/chris-bluemoon)
