// Game state
let prizeLocation;
let selectedDoor;
let revealedDoor;
let gamePhase = 'selection'; // 'selection', 'reveal', or 'final'
const prizeImage = './images/prize.jpg';
const goatImage = './images/goat.jpg';

// DOM Elements
const doorsDiv = document.getElementById('doors');
const messageDiv = document.getElementById('message');
const resetButton = document.getElementById('resetButton');

// Initialize game
function initGame() {
    // Reset game state
    prizeLocation = Math.floor(Math.random() * 3);
    selectedDoor = null;
    revealedDoor = null;
    gamePhase = 'selection';
    
    // Clear previous doors
    doorsDiv.innerHTML = '';
    messageDiv.textContent = 'Choose a door!';
    
    // Create doors
    for (let i = 0; i < 3; i++) {
        const door = document.createElement('div');
        door.className = 'door';
        
        // Add door number
        const doorNumber = document.createElement('div');
        doorNumber.className = 'door-number';
        doorNumber.textContent = i + 1;
        door.appendChild(doorNumber);
        
        door.onclick = () => handleDoorClick(i);
        doorsDiv.appendChild(door);
    }
}

// Handle door clicks
function handleDoorClick(doorNumber) {
    const doors = document.querySelectorAll('.door');
    
    if (gamePhase === 'selection') {
        // First selection
        selectedDoor = doorNumber;
        doors[doorNumber].classList.add('selected');
        
        // Find a door to reveal (not the prize door and not the selected door)
        let availableDoors = [0, 1, 2].filter(d => d !== prizeLocation && d !== selectedDoor);
        revealedDoor = availableDoors[Math.floor(Math.random() * availableDoors.length)];
        
        // Reveal the goat
        doors[revealedDoor].classList.add('open');
        const revealedDoorImg = document.createElement('img');
        revealedDoorImg.src = goatImage;
        revealedDoorImg.alt = 'Goat';
        revealedDoorImg.className = 'door-image';
        doors[revealedDoor].appendChild(revealedDoorImg);
        
        gamePhase = 'final';
        messageDiv.innerHTML = 'Would you like to switch your choice?<br>Click a door to make your final decision.';
        
    } else if (gamePhase === 'final' && doorNumber !== revealedDoor) {
        // Final selection
        const wonPrize = doorNumber === prizeLocation;
        
        // Reveal all doors
        doors.forEach((door, i) => {
            door.classList.remove('selected');
            if (i === doorNumber) {
                door.classList.add('final');
            }
            door.classList.add('open');
            
            if (i !== revealedDoor) {
                const img = document.createElement('img');
                img.src = i === prizeLocation ? prizeImage : goatImage;
                img.alt = i === prizeLocation ? 'Prize' : 'Goat';
                img.className = 'door-image';
                door.appendChild(img);
            }
        });
        
        // Show result message with properly sized image
        const resultImg = document.createElement('img');
        resultImg.src = prizeImage;
        resultImg.alt = 'Prize';
        resultImg.style.width = '150px';
        resultImg.style.height = '150px';
        resultImg.style.objectFit = 'contain';
        resultImg.style.margin = '20px auto';
        resultImg.style.display = 'block';
        
        messageDiv.innerHTML = wonPrize ? 
            'Congratulations! You won the prize!' :
            `Sorry! The prize was behind door ${prizeLocation + 1}.`;
        messageDiv.appendChild(resultImg);
        
        gamePhase = 'over';
    }
}

// Reset game when button is clicked
resetButton.onclick = initGame;

// Start the game
initGame();
