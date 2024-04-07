# Define the size of the grid
$width = 20
$height = 10

# Create the grid with random initial states
# Initialize a two-dimensional array to represent the grid
$grid = New-Object 'int[,]' $height, $width
for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        # Assign random initial state (alive or dead) to each cell in the grid
        $grid[$y, $x] = Get-Random -Minimum 0 -Maximum 2
    }
}

# Function to print the current state of the grid
function Print-Grid($grid) {
    cls # Clear the screen before printing the new state
    for ($y = 0; $y -lt $grid.GetLength(0); $y++) {
        for ($x = 0; $x -lt $grid.GetLength(1); $x++) {
            # Print a solid block for alive cells, and a space for dead cells
            if ($grid[$y, $x] -eq 1) {
                Write-Host "█" -NoNewline
            } else {
                Write-Host " " -NoNewline
            }
        }
        Write-Host # Move to the next line after printing each row
    }
}

# Function to calculate the number of alive neighbors for a given cell
function Get-AliveNeighbors($grid, $x, $y) {
    $aliveNeighbors = 0
    for ($dx = -1; $dx -le 1; $dx++) {
        for ($dy = -1; $dy -le 1; $dy++) {
            # Skip the cell itself
            if (-not($dx -eq 0 -and $dy -eq 0)) {
                $nx = $x + $dx
                $ny = $y + $dy
                # Check boundaries and increment count of alive neighbors if necessary
                if ($nx -ge 0 -and $nx -lt $grid.GetLength(1) -and $ny -ge 0 -and $ny -lt $grid.GetLength(0)) {
                    $aliveNeighbors += $grid[$ny, $nx]
                }
            }
        }
    }
    return $aliveNeighbors
}

# Main game loop - this runs indefinitely
do {
    # Create a new grid for the next generation
    $newGrid = New-Object 'int[,]' $height, $width
    for ($y = 0; $y -lt $height; $y++) {
        for ($x = 0; $x -lt $width; $x++) {
            # Calculate alive neighbors for the current cell
            $aliveNeighbors = Get-AliveNeighbors $grid $x $y
            # Apply the rules of Conway's Game of Life
            if ($grid[$y, $x] -eq 1) {
                # Cell stays alive if it has 2 or 3 neighbors, otherwise dies
                $newGrid[$y, $x] = [int]($aliveNeighbors -eq 2 -or $aliveNeighbors -eq 3)
            } else {
                # A dead cell becomes alive if it has exactly 3 alive neighbors
                $newGrid[$y, $x] = [int]($aliveNeighbors -eq 3)
            }
        }
    }
    # Update the grid for the next generation
    $grid = $newGrid
    # Print the new state of the grid
    Print-Grid $grid
    # Pause to allow observation (Commented out to speed up the simulation)
    #Start-Sleep -Milliseconds 200
} while ($true) # The loop will continue indefinitely until manually stopped
