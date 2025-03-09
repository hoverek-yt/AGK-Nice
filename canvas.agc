function CreateCanvas(width as integer, height as integer)
	_m = CreateMemblock(12 + (width * height * 4))
	SetMemblockInt(_m, 0, width) 		// Width
	SetMemblockInt(_m, 4, height) 	// Height
	SetMemblockInt(_m, 8, 1)  		// RGBA8 Format
endfunction _m

function SetCanvasPixel(memID as integer, x as integer, y as integer, red as integer, green as integer, blue as integer, alpha as integer)
    width = GetMemblockInt(memID, 0)
    height = GetMemblockInt(memID, 4)
    
    // Check if pixel is in image area
    if x >= 0 and x < width and y >= 0 and y < height
        offset = 12 + (y * width + x) * 4
        
        // Color values: (R, G, B, A)
        SetMemblockByte(memID, offset,   red) // R
        SetMemblockByte(memID, offset+1, green) // G
        SetMemblockByte(memID, offset+2, blue) // B
        SetMemblockByte(memID, offset+3, alpha) // A
    endif
endfunction

function SetCanvasPixelPattern(memID as integer, pixelCount as integer, x as integer, y as integer, red as integer, green as integer, blue as integer, alpha as integer)
	available as integer[]
	occupied as integer[]
	patternMemID as integer
	
	// Creating empty memblock with size of 9 bytes
	patternMemID = CreateMemblock(9)
	for i = 0 to 8
		SetMemblockByte(patternMemID, i, 0)
		available.insert(i) // List of available indexes (0-8)
	next i
	
	// Limit pixelCount to maximum of 9
	if pixelCount > 9 then pixelCount = 9
	
	// Picking random indexes
	for i = 0 to pixelCount - 1
		randIndex = Random(0, available.length - 1) // Random index in available list
		selected = available[randIndex] // Getting value from available indeksóindexes
		
		occupied.insert(selected) // Adding to occupied
		available.remove(randIndex) // Deleting from available
	next i
	
	// Updating memblock
	for i = 0 to occupied.length
		SetMemblockByte(patternMemID, occupied[i], 1)
	next i
	
	
	if GetMemblockByte(patternMemID, 0) then SetCanvasPixel(memID, x + 0, y + 0, red, green, blue, alpha)
	if GetMemblockByte(patternMemID, 1) then SetCanvasPixel(memID, x + 1, y + 0, red, green, blue, alpha)
	if GetMemblockByte(patternMemID, 2) then SetCanvasPixel(memID, x + 2, y + 0, red, green, blue, alpha)
	if GetMemblockByte(patternMemID, 3) then SetCanvasPixel(memID, x + 0, y + 1, red, green, blue, alpha)
	if GetMemblockByte(patternMemID, 4) then SetCanvasPixel(memID, x + 1, y + 1, red, green, blue, alpha)
	if GetMemblockByte(patternMemID, 5) then SetCanvasPixel(memID, x + 2, y + 1, red, green, blue, alpha)
	if GetMemblockByte(patternMemID, 6) then SetCanvasPixel(memID, x + 0, y + 2, red, green, blue, alpha)
	if GetMemblockByte(patternMemID, 7) then SetCanvasPixel(memID, x + 1, y + 2, red, green, blue, alpha)
	if GetMemblockByte(patternMemID, 8) then SetCanvasPixel(memID, x + 2, y + 2, red, green, blue, alpha)

	DeleteMemblock(patternMemID)
endfunction
