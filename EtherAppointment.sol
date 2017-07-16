pragma solidity ^0.4.11;


contract EtherAppointment  {
   
    mapping (address => Participant) public participants;
    mapping (uint => address) participantsByIndex;
    
    
    event Address_given(address from);
    
    uint[] proposed_dates;
    uint found_date; 
    
    struct Date {
        
        dateStatus status;
        uint timestamp;
        
    }
    
    enum dateStatus { YES, NO, MAYBE }
    
    struct Participant {
        
        bool active;
        Date[] confirmed_dates;
        bool organizer; 
    
    }
    
    
    address organizer;
    uint totalNumberOfParticipants;
    
    modifier onlyParticipant() {
        if (participants[msg.sender].active == false) throw;
        _;
    }
   
   modifier onlyOrganizer() {
        if  (msg.sender != organizer) throw;
        _;
    }
    
    function EtherAppointment  (address _sender) {
        
        organizer = _sender;
        participants[organizer].active = true;
        participants[organizer].organizer = true;
        participantsByIndex[totalNumberOfParticipants] = organizer;
        totalNumberOfParticipants++;
       
    
    }
    
    function getDateResult(address _participant) constant public returns (uint[],uint[]) {
        
        uint[] memory time_stamps = new uint[](participants[_participant].confirmed_dates.length);
        uint[] memory status = new uint[](participants[_participant].confirmed_dates.length);
        
        for (uint i = 0; i<participants[_participant].confirmed_dates.length;i++) {
            
            time_stamps[i] = participants[_participant].confirmed_dates[i].timestamp;
            status[i] = uint(participants[_participant].confirmed_dates[i].status);
        }
        
      return (time_stamps,status);
    }
    
    function addParticipants  (address[] _participants) onlyOrganizer {
        
        for (uint i = 0;i<_participants.length;i++) { 
        
             if (participants[_participants[i]].active) {
                 throw;}
             else {
                
                participants[_participants[i]].active = true;
                participantsByIndex[totalNumberOfParticipants] = _participants[i];
                totalNumberOfParticipants++;}
        }
    }
    
    function removeParticipant (address _participant) onlyOrganizer {
        
              participants[_participant].active = false;
             
              for (uint8 i = 0; i < totalNumberOfParticipants; i++) {
                  
                  address cl = participantsByIndex[i];
                  if (_participant == cl) {
                      
                      delete participantsByIndex[i];
                      totalNumberOfParticipants--;
                      
                  }
                  
              }
              
            
        
    }
    
    function getAllParticpants()  constant public returns(address[]) {
        
        address[] memory allParticipants = new address[](totalNumberOfParticipants);
        uint j = 0;
        for (uint i = 0; i < totalNumberOfParticipants; i++) {
            address participant = participantsByIndex[i];
            if (participants[participant].active == true) {
                allParticipants[j] = participant;
                j++;
            } 
        }
        return allParticipants;
    }
    
    function confirmDates (uint[] _confirmed_dates,uint[] _status) onlyParticipant {
        
        delete(participants[msg.sender].confirmed_dates);
        for (uint i = 0; i < _confirmed_dates.length; i++) {
             
            Date memory d;
            d.timestamp=_confirmed_dates[i];
            d.status=dateStatus(_status[i]);
             
            participants[msg.sender].confirmed_dates.push(d);
         
        }
        
    }
    function setProposals (uint[] _proposals) onlyOrganizer {
        
        proposed_dates = _proposals;
    }      
        
    function getProposals () onlyOrganizer constant public returns (uint[])  {
        
        return proposed_dates;
    }      
    
    function setFoundDate (uint _timestamp)  onlyOrganizer {
        
        found_date = _timestamp;
    } 
    
    function getFoundDate () constant public returns (uint) {
        
        return found_date;
    } 
}
