// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


/// @title A contract for voting for Wakandan UN Officials
/// @author Milos Dograjic
/// @notice For now this contract is simulating the Wakandan voting mechanism
contract WakandaVoting {

    address owner;

    constructor(){
        owner = msg.sender;
    }

    
    event NewChallenger(string _name);
    event Voted(string _name);

    struct Candidate{
        uint id;
        string name;
        uint votes;
        bool exists;
    }

    Candidate[] public candidates;

    mapping (string => Candidate) leaderboard;
    mapping (address => bool) votingFeePayed;
    mapping (address => mapping(string => bool)) voterToCandidate;
    
    /// @notice Modifier that checks if WKND amount was payed for voting
    /// @dev implementation done for now
    modifier feePayed(address _sender){
        require(votingFeePayed[_sender] == true, "Payment not registered on blockhain!");
        _;
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    
    modifier alreadyVotedForCandidate(string memory _name){
        require(voterToCandidate[msg.sender][_name] == false, "You cannot vote twice for one candidate!");
        _;
    }

    /// @notice This function returns the list of top 3 candidates
    /// @dev implementation done for now
    function _createCandidate(uint _id, string memory _name) private {
        Candidate memory newCand = Candidate(_id, _name, 1, true);
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


    function vote(uint _candidateId, string memory _name, bool _payed) external alreadyVotedForCandidate(_name){
        require(_payed == true);
        address sender = msg.sender;
        votingFeePayed[sender] = true;
        _voteForCandidate(sender, _candidateId, _name);
    }

    /// @notice This function is used for voting for a candidate
    /// @param _candidateId id of the candidate
    /// @dev implementation done for now 
    function _voteForCandidate(address _sender, uint _candidateId, string memory _name) private feePayed(_sender){
        bool exists = false;
        votingFeePayed[msg.sender] = false;
        voterToCandidate[_sender][_name] = true;
        emit Voted(_name);
    
        for(uint i = 0; i < candidates.length; i++){ //we have 10 candidates
            if(candidates[i].id == _candidateId){
                exists = true;
                candidates[i].votes = candidates[i].votes + 1;
                uint votes = candidates[i].votes;
                
                if(votes > leaderboard["first"].votes){
                    _checkLeaderboardOrder(candidates[i]);

                    leaderboard["third"] = leaderboard["second"];
                    leaderboard["second"] = leaderboard["first"];
                    leaderboard["first"] = candidates[i];
                }
                else if(votes > leaderboard["second"].votes){
                    _checkLeaderboardOrder(candidates[i]);

                    leaderboard["third"] = leaderboard["second"];
                    leaderboard["second"] = candidates[i];
                }
                else if(votes > leaderboard["third"].votes){
                    _checkLeaderboardOrder(candidates[i]);
                    leaderboard["third"] = candidates[i];
                } 
            }
        }

        if(exists == false){
            _createCandidate(_candidateId, _name);
        }
    }


    /// @notice This function is used for checking if a new canidate entered the top 3 on the leaderboard
    /// @param _cand Candidate for which we check the leaderboard
    /// @dev implementation done for now 
    function _checkLeaderboardOrder(Candidate memory _cand) private{
        if(_cand.id !=leaderboard["first"].id
            &&_cand.id != leaderboard["second"].id
            && _cand.id != leaderboard["third"].id){
            
            emit NewChallenger(_cand.name);
        }
    }



}