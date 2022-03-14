import React, { Component } from "react";
import getWeb3 from "./getWeb3";
import Platform from "./contracts/Platform.json";

import "./App.css";

class App extends Component {
  constructor() {
    super();
    this.state = {
      web3: null,
      accounts: [],
      manager: '',
      platformContract: null,
      allCrowd: [],
      sponsorCrowd: [],
      votingCrowdpros: []
    }
  }

  async componentWillMount() {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = Platform.networks[networkId];
      const platformContract = new web3.eth.Contract(
          Platform.abi,
          deployedNetwork && deployedNetwork.address,
      );
      const manager = await platformContract.methods.owner().call();
      const allCrowd = await platformContract.methods.getAllCrowd().call();
      const sponsorCrowd = await platformContract.methods.getSponsorCrowd().call();
      const votingCrowdpros = await platformContract.methods.getVotingCrowdpros().call();

      this.setState({ web3, accounts, manager, platformContract, allCrowd, sponsorCrowd, votingCrowdpros   });
      console.log(accounts)
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };


  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <h1>{this.state.accounts}</h1>
        <h1>{this.state.manager}</h1>
        <h1>{this.state.allCrowd}</h1>
        <h1>{this.state.sponsorCrowd}</h1>
        <h1>{this.state.votingCrowdpros}</h1>
      </div>
    );
  }
}

export default App;
