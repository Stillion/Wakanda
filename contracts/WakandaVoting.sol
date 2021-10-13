// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./token/WKND.sol";

/// @title A contract for voting for Wakandan UN Officials
/// @author Milos Dograjic
/// @notice For now this contract is simulating the Wakandan voting mechanism
contract WakandaVoting {

    event NewChallenger(string name);

    struct Candidate{
        string name;
        uint votes;
        address ethAddress;
        bool exists;
    }

    mapping (string => Candidate) leaderboard;

    Candidate[] public candidates;

    /// @notice This function returns the list of top 3 candidates
    /// @dev implementation done for now
    function _createCandidate(string memory _name, address _ethAddress) private {
        Candidate memory newCand = Candidate(_name, 1, _ethAddress, true);
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
    function winningCandidates() public view returns(Candidate[3] memory){ 
        Candidate[3] memory currentLeaders;
        currentLeaders[0] = leaderboard["first"];
        currentLeaders[0] = leaderboard["second"];
        currentLeaders[0] = leaderboard["third"];

        return currentLeaders;
    }

    /// @notice This function is used for voting for a candidate
    /// @param _name name of the candidate
    /// @param _candidateAddress ethereum address of the candidate
    /// @param _wkndAmount amount of wknd used for voting
    /// @dev implement WKND transfer 
    function voteForCandidate(string memory _name, address _candidateAddress, uint _wkndAmount) public{
        require(_wkndAmount == 1);

        bool exists = false;
        
        for(uint i = 0; i < candidates.length; i++){
            if(candidates[i].ethAddress == _candidateAddress){
                exists = true;
                candidates[i].votes = candidates[i].votes + 1;
                //add transfer of WKND

                if(candidates[i].votes > leaderboard["first"].votes){
                    leaderboard["third"] = leaderboard["second"];
                    leaderboard["second"] = leaderboard["first"];
                    leaderboard["first"] = candidates[i];

                    if(candidates[i].ethAddress != leaderboard["first"].ethAddress
                        && candidates[i].ethAddress != leaderboard["second"].ethAddress
                        && candidates[i].ethAddress != leaderboard["third"].ethAddress){
                        
                        emit NewChallenger(candidates[i].name);
                    }
                }
                else if(candidates[i].votes > leaderboard["second"].votes){
                    leaderboard["third"] = leaderboard["second"];
                    leaderboard["second"] = candidates[i];

                    if(candidates[i].ethAddress != leaderboard["first"].ethAddress
                        && candidates[i].ethAddress != leaderboard["second"].ethAddress
                        && candidates[i].ethAddress != leaderboard["third"].ethAddress){
                        
                        emit NewChallenger(candidates[i].name);
                    }
                }
                else if(candidates[i].votes > leaderboard["third"].votes){
                    leaderboard["third"] = candidates[i];
                    
                    if(candidates[i].ethAddress != leaderboard["first"].ethAddress
                        && candidates[i].ethAddress != leaderboard["second"].ethAddress
                        && candidates[i].ethAddress != leaderboard["third"].ethAddress){
                        
                        emit NewChallenger(candidates[i].name);
                    }
                } 
            }
        }

        if(exists == false){
            _createCandidate(_name, _candidateAddress);
        }
    }



}