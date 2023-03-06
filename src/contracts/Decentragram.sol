// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0; 

contract Decentragram {
  string public name;
  uint public imageCount = 0;
  mapping(uint => Image) public images;

  struct Image {
    uint id;
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }

  event ImageCreated(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  event ImageTipped(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );
    
    constructor()  {
    name = "Decentragram";
  }

  function uploadImage(string memory _imgHash, string memory _description) public {

    // Imagehash and descrption should not be empty
    require(bytes(_imgHash).length > 0);
    require(bytes(_description).length > 0);
    require(msg.sender!=address(0));

    imageCount ++;

    // Add Image to the contract
    images[imageCount] = Image(imageCount, _imgHash, _description, 0, payable(msg.sender));

    emit ImageCreated(imageCount, _imgHash, _description, 0, payable(msg.sender));
  }

  function tipImageOwner(uint _id) public payable {
    
    require(_id > 0 && _id <= imageCount);
    // Fetch the image and author
    Image memory _image = images[_id];

    address _author = _image.author;
   
    // Transferring the tip to author 
    payable(address(_author)).transfer(msg.value);
   
    _image.tipAmount = _image.tipAmount + msg.value;

    // Update the image
    images[_id] = _image;
  
    emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, payable(_author));
  }
}