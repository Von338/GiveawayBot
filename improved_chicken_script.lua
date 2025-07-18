-- Improved Chicken Event Script
-- Enhanced version with better practices and error handling

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Configuration
local CONFIG = {
    EVENTS_PER_BATCH = 250,
    BATCH_DELAY = 0.1,
    MAX_RETRIES = 5,
    RETRY_DELAY = 1,
    TIMEOUT_DURATION = 30
}

-- State management
local ScriptState = {
    isActive = true,
    eventConnection = nil,
    startTime = tick()
}

-- Utility functions
local function logMessage(message, messageType)
    messageType = messageType or "INFO"
    local timestamp = os.date("%H:%M:%S")
    print(string.format("[%s] [%s] %s", timestamp, messageType, message))
end

local function waitForEvent(parent, eventName, timeout)
    timeout = timeout or CONFIG.TIMEOUT_DURATION
    local startTime = tick()
    
    while not parent:FindFirstChild(eventName) do
        if tick() - startTime > timeout then
            return nil
        end
        wait(0.1)
    end
    
    return parent:FindFirstChild(eventName)
end

local function validateEventStructure()
    -- Wait for ReplicatedStorage to be ready
    if not ReplicatedStorage then
        logMessage("ReplicatedStorage service not available", "ERROR")
        return false
    end
    
    -- Try to find ChickenEvent with timeout
    local chickenEvent = waitForEvent(ReplicatedStorage, "ChickenEvent", CONFIG.TIMEOUT_DURATION)
    if not chickenEvent then
        logMessage("ChickenEvent not found in ReplicatedStorage after timeout", "ERROR")
        return false
    end
    
    -- Try to find RemoteEvent with timeout
    local remoteEvent = waitForEvent(chickenEvent, "RemoteEvent", CONFIG.TIMEOUT_DURATION)
    if not remoteEvent then
        logMessage("RemoteEvent not found in ChickenEvent after timeout", "ERROR")
        return false
    end
    
    -- Validate that it's actually a RemoteEvent
    if not remoteEvent:IsA("RemoteEvent") then
        logMessage("Found object is not a RemoteEvent", "ERROR")
        return false
    end
    
    logMessage("Event structure validated successfully", "SUCCESS")
    return remoteEvent
end

local function createSafeFireFunction(event)
    return function(args)
        local success, errorMessage = pcall(function()
            event:FireServer(unpack(args))
        end)
        
        if not success then
            logMessage("Failed to fire event: " .. tostring(errorMessage), "ERROR")
            return false
        end
        return true
    end
end

local function executeEventBatch(fireFunction, args, batchSize)
    local successCount = 0
    local failureCount = 0
    
    for i = 1, batchSize do
        if not ScriptState.isActive then
            logMessage("Script stopped during batch execution", "INFO")
            break
        end
        
        if fireFunction(args) then
            successCount = successCount + 1
        else
            failureCount = failureCount + 1
        end
        
        -- Add small delay every 50 events to prevent overwhelming
        if i % 50 == 0 then
            wait(0.01)
        end
    end
    
    return successCount, failureCount
end

local function setupStopConditions()
    -- Stop when player leaves
    local player = Players.LocalPlayer
    if player then
        ScriptState.eventConnection = player.AncestryChanged:Connect(function()
            if not player.Parent then
                logMessage("Player left game, stopping script", "INFO")
                ScriptState.isActive = false
            end
        end)
    end
    
    -- Stop after a reasonable time limit (optional safety measure)
    spawn(function()
        wait(300) -- 5 minutes
        if ScriptState.isActive then
            logMessage("Script auto-stopped after 5 minutes for safety", "INFO")
            ScriptState.isActive = false
        end
    end)
end

local function cleanup()
    ScriptState.isActive = false
    
    if ScriptState.eventConnection then
        ScriptState.eventConnection:Disconnect()
        ScriptState.eventConnection = nil
    end
    
    logMessage("Script cleanup completed", "INFO")
end

-- Main execution function
local function main()
    logMessage("Starting Chicken Event Script", "INFO")
    
    -- Validate event structure with retries
    local event = nil
    local retryCount = 0
    
    while retryCount < CONFIG.MAX_RETRIES and not event do
        event = validateEventStructure()
        if not event then
            retryCount = retryCount + 1
            if retryCount < CONFIG.MAX_RETRIES then
                logMessage(string.format("Retry %d/%d in %d seconds...", retryCount, CONFIG.MAX_RETRIES, CONFIG.RETRY_DELAY), "WARN")
                wait(CONFIG.RETRY_DELAY)
            end
        end
    end
    
    if not event then
        logMessage("Failed to find event after all retries. Script terminated.", "ERROR")
        return
    end
    
    -- Setup safety conditions
    setupStopConditions()
    
    -- Create safe fire function
    local safeFireEvent = createSafeFireFunction(event)
    local args = {{ action = "shoot" }}
    
    -- Statistics tracking
    local totalEvents = 0
    local totalBatches = 0
    local totalFailures = 0
    
    logMessage("Starting event firing loop", "INFO")
    
    -- Main loop
    while ScriptState.isActive do
        local batchStartTime = tick()
        local successCount, failureCount = executeEventBatch(safeFireEvent, args, CONFIG.EVENTS_PER_BATCH)
        
        totalEvents = totalEvents + successCount
        totalFailures = totalFailures + failureCount
        totalBatches = totalBatches + 1
        
        -- Log progress every 10 batches
        if totalBatches % 10 == 0 then
            local elapsedTime = tick() - ScriptState.startTime
            local eventsPerSecond = totalEvents / elapsedTime
            logMessage(string.format("Progress: %d batches, %d events fired, %.1f events/sec", 
                     totalBatches, totalEvents, eventsPerSecond), "INFO")
        end
        
        -- Check for too many failures
        if totalFailures > totalEvents * 0.1 then -- More than 10% failure rate
            logMessage("High failure rate detected, stopping script", "ERROR")
            break
        end
        
        -- Wait before next batch
        wait(CONFIG.BATCH_DELAY)
    end
    
    -- Final statistics
    local totalTime = tick() - ScriptState.startTime
    logMessage(string.format("Script completed: %d events in %.1f seconds (%.1f events/sec)", 
             totalEvents, totalTime, totalEvents / totalTime), "SUCCESS")
    
    cleanup()
end

-- Error handling wrapper
local function safeMain()
    local success, errorMessage = pcall(main)
    if not success then
        logMessage("Script error: " .. tostring(errorMessage), "ERROR")
        cleanup()
    end
end

-- Start the script
safeMain()