let doorsCount = 3; // Configurable number of doors (3-10)
let doors = [];
let selectedDoor = null;
let winningDoor = null;

const prizeImage = 'images/prize.jpg'; // Replace with actual car image path
const goatImage = 'images/goat.jpg'; // Replace with actual goat image path

function initGame() {
    doors = Array.from({ length: doorsCount }, (_, i) => ({
        id: i + 1,
        isWinner: false,
        isOpened: false
    }));

    // Randomly select a winning door
    winningDoor = Math.floor(Math.random() * doorsCount);
    doors[winningDoor].isWinner = true;

    renderDoors();
    document.getElementById('message').innerHTML = ''; // Clear any previous messages
    selectedDoor = null; // Reset selected door
}

function renderDoors() {
    const doorsDiv = document.getElementById('doors');
    doorsDiv.innerHTML = '';

    doors.forEach(door => {
        const doorDiv = document.createElement('div');
        doorDiv.className = `door ${door.isOpened ? 'open' : 'closed'} ${selectedDoor === door.id ? 'selected' : ''}`;

        // Add door number
        const numberDiv = document.createElement('div');
        numberDiv.className = 'door-number';
        numberDiv.textContent = `Door ${door.id}`;
        doorDiv.appendChild(numberDiv);

        if (door.isOpened) {
            // Show prize or goat when opened
            const img = document.createElement('img');
            img.src = door.isWinner ? prizeImage : goatImage;
            doorDiv.appendChild(img);
        }

        doorDiv.onclick = () => selectDoor(door.id);
        doorsDiv.appendChild(doorDiv);
    });
}

function selectDoor(id) {
    if (selectedDoor !== null) return; // Prevent selecting another door

    selectedDoor = id;

    // Highlight the selected door and show selection message
    renderDoors();

    // Open other goat doors after a delay
    setTimeout(() => {
        showSwitchOption();
    }, 1000);
}

function showSwitchOption() {
    const messageDiv = document.getElementById('message');

    // Find available doors to reveal (goats only)
    const availableDoors = doors
        .map((door, index) => ({ ...door, index }))
        .filter(door =>
            !door.isOpened &&
            door.index !== (selectedDoor - 1) &&
            !door.isWinner
        );

    // Determine how many doors to open
    const doorsToOpenCount = doorsCount - 2; // Always leave 2 doors closed

    // Open the required number of goat doors
    const doorsToOpen = availableDoors.slice(0, doorsToOpenCount);
    doorsToOpen.forEach(door => {
        doors[door.index].isOpened = true;
    });

    renderDoors();

    messageDiv.innerHTML = `
        You picked Door ${selectedDoor}.
        Would you like to switch?
        <button onclick="switchDoor()">Switch</button>
        <button onclick="finishGame()">Stay</button>`;
}

function switchDoor() {
   const newSelectedDoor = doors.findIndex((door, index) =>
       !door.isOpened &&
       index !== (selectedDoor - 1)
   ) + 1;

   finishGame(newSelectedDoor);
}

function finishGame(newSelectedDoor) {
   const messageDiv = document.getElementById('message');
   const finalSelection = newSelectedDoor || selectedDoor;

   // Mark all doors as opened for final display
   doors.forEach(door => door.isOpened = true);
   renderDoors();

   if (doors[finalSelection - 1].isWinner) {
       messageDiv.innerHTML += `<p>Congratulations! You won by picking Door ${finalSelection}!</p>`;
       messageDiv.innerHTML += `<img src="${prizeImage}" alt="Prize" style="width:100px;">`; // Show car image on win
   } else {
       messageDiv.innerHTML += `<p>Sorry! You picked Door ${finalSelection}. The winning door was ${winningDoor + 1}.</p>`;
       messageDiv.innerHTML += `<img src="${prizeImage}" alt="Prize" style="width:100px;">`; // Show car image even on loss
   }

   selectedDoor = null; // Reset selection for next game
}

document.getElementById('resetButton').onclick = initGame;

// Start the game on page load
initGame();
