//izmeniti ABI za contract, kao i adrese

if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    // set the provider you want from Web3.providers
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}
web3.eth.defaultAccount = web3.eth.accounts[0];
var WakandaVoting = new web3.eth.Contract([

], '0x17D203e99F74D71a03353a91D824e8F1B08443ae', // contract address
{
    from: '0xb13622Bd3650d2e7f28cf8BA588A2b7b2594F4A7', // default from address
    gasPrice: '20000' // default gas price in wei, 20 gwei in this case
});

// console.log(ApartmentRent);
// console.log(web3.eth.accounts);
WakandaVoting.methods.getAllApartments().call(function (error, result) {
    if (!error) {
        $("#apartment").html(result);
    }
    else{
        console.error(error);
        alert("Error occured while getting the apartment list!");
    }
});

