// Game state
let prizeLocation;
let selectedDoor;
let revealedDoor;
let gamePhase = 'selection'; // 'selection', 'reveal', or 'final'
const prizeImage = 'images/prize.jpg';
const goatImage = 'images/goat.jpg';

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
        door.textContent = `${i + 1}`;
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
        doors[revealedDoor].classList.add('revealed');
        doors[revealedDoor].innerHTML = `${revealedDoor + 1}<br><img src="${goatImage}" alt="Goat" style="width:100px;">`;
        
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
            if (i === prizeLocation) {
                door.innerHTML = `${i + 1}<br><img src="${prizeImage}" alt="Prize" style="width:100px;">`;
            } else if (i !== revealedDoor) {
                door.innerHTML = `${i + 1}<br><img src="${goatImage}" alt="Goat" style="width:100px;">`;
            }
        });
        
        // Show result message
        messageDiv.innerHTML = wonPrize ? 
            `Congratulations! You won the prize!<br><img src="${prizeImage}" alt="Prize" style="width:100px;">` :
            `Sorry! The prize was behind door ${prizeLocation + 1}.<br><img src="${prizeImage}" alt="Prize" style="width:100px;">`;
        
        gamePhase = 'over';
    }
}

// Reset game when button is clicked
resetButton.onclick = initGame;

// Start the game
initGame();
