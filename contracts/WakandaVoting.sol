// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./token/WKNDToken.sol";
import "./token/WKNDFaucet.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/// @title A contract for voting for Wakandan UN Officials
/// @author Milos Dograjic
/// @notice For now this contract is simulating the Wakandan voting mechanism
contract WakandaVoting {

    using SafeMath for uint;

    address owner;
    WKNDToken WToken;
    WKNDFaucet WFaucet;
    address tokenAddress = 0x150458678Acf69224047d3bDa31BA0B944B5d1ff;
    address payable faucetAddress = payable(0xd49075AE6335A4E007729507dcF69Dfcad91803C);

    constructor(){
        owner = msg.sender;
        WToken = WKNDToken(tokenAddress);
        WFaucet = WKNDFaucet(faucetAddress); 
    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    event NewChallenger(string name);

    struct Candidate{
        uint id;
        string name;
        uint votes;
        bool exists;
    }

    Candidate[] public candidates;

    mapping (string => Candidate) leaderboard;
    mapping (address => bool) votingFeePayed;

    
    /// @notice Modifier that checks if WKND amount was payed for voting
    /// @dev implementation done for now
    modifier feePayed(){
        require(votingFeePayed[msg.sender] == true);
        _;
    }


    /// @notice This function returns the list of top 3 candidates
    /// @dev implementation done for now
    function _createCandidate(string memory _name) private {
        uint id = candidates.length;
        Candidate memory newCand = Candidate(id, _name, 1, true);
        candidates.push(newCand);

        if(leaderboard["first"].exists == false){
            leaderboard["first"] = newCand;
            emit NewChallenger(_name);
        }
        else if(leaderboard["second"].exists == false){
            leaderboard["second"] = newCand;
            emit NewChallenger(_name);
        }
        else if(leaderboard["third"].exists == false){
            leaderboard["third"] = newCand;
            emit NewChallenger(_name);
        }
    }

    /// @notice This function returns the list of top 3 candidates
    /// @return result - list of currently top 3 winning candidates
    /// @dev implementation done for now 
    function winningCandidates() external view returns(Candidate[3] memory){ 
        Candidate[3] memory currentLeaders;
        currentLeaders[0] = leaderboard["first"];
        currentLeaders[1] = leaderboard["second"];
        currentLeaders[2] = leaderboard["third"];
 
        return currentLeaders;
    }


    function vote(string memory _name, uint tokenAmount) external{
        require(tokenAmount == 10000000000000000);
        votingFeePayed[msg.sender] = true;
        _voteForCandidate(_name);
    }

    /// @notice This function is used for voting for a candidate
    /// @param _name name of the candidate
    /// @dev implementation done for now 
    function _voteForCandidate(string memory _name) private feePayed{
        bool exists = false;
        votingFeePayed[msg.sender] = false;
        
        for(uint i = 0; i < candidates.length; i.add(1)){
            if(keccak256(bytes(candidates[i].name)) == keccak256(bytes(_name))){
                exists = true;
                candidates[i].votes = candidates[i].votes.add(1);

                if(candidates[i].votes > leaderboard["first"].votes){
                    _checkLeaderboardOrder(candidates[i]);

                    leaderboard["third"] = leaderboard["second"];
                    leaderboard["second"] = leaderboard["first"];
                    leaderboard["first"] = candidates[i];
                }
                else if(candidates[i].votes > leaderboard["second"].votes){
                    _checkLeaderboardOrder(candidates[i]);

                    leaderboard["third"] = leaderboard["second"];
                    leaderboard["second"] = candidates[i];
                }
                else if(candidates[i].votes > leaderboard["third"].votes){
                    _checkLeaderboardOrder(candidates[i]);
                    leaderboard["third"] = candidates[i];
                } 
            }
        }

        if(exists == false){
            _createCandidate(_name);
        }
    }


    /// @notice This function is used for checking if a new canidate entered the top 3 on the leaderboard
    /// @param _cand Candidate for which we check the leaderboard
    /// @dev implementation done for now 
    function _checkLeaderboardOrder(Candidate memory _cand) private{
        if(keccak256(bytes(_cand.name)) != keccak256(bytes(leaderboard["first"].name))
            && keccak256(bytes(_cand.name)) != keccak256(bytes(leaderboard["second"].name))
            && keccak256(bytes(_cand.name)) != keccak256(bytes(leaderboard["third"].name))){
            
            emit NewChallenger(_cand.name);
        }
    }



}