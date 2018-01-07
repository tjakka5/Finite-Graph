local Graph = require("graph")

local Map = Graph()

local totalNodes   = 12
local minDist      = 40
local maxLinkDist  = 125
local forceConnect = true

local minSquaredDist     = minDist * minDist
local maxSquaredLinkDist = maxLinkDist * maxLinkDist

local nodes = {}

function love.load()
   local w, h = love.graphics.getDimensions()
   for i = 1, totalNodes do
      local node = Map:addNode()

      local allowed = false
      local x, y    = 0, 0

      while not allowed do
         allowed = true

         x = love.math.random(minDist, w - minDist)
         y = love.math.random(minDist, h - minDist)

         for _, other in ipairs(nodes) do
            local dx = x - other.x
            local dy = y - other.y

            local dist = dx*dx + dy*dy
            if dist <= minSquaredDist then
               allowed = false
            end
         end
      end

      node.x = x
      node.y = y

      nodes[#nodes + 1] = node
   end

   for i = 1, totalNodes do
      local node = nodes[i]

      local connectedAny       = false
      local closestUnconnected = nil
      local closestDist        = math.huge

      for j = i + 1, totalNodes do
         local other = nodes[j]

         local dx = node.x - other.x
         local dy = node.y - other.y

         local dist = dx*dx + dy*dy
         if dist <= maxSquaredLinkDist then
            node:connectTo(other)
            connectedAny = true
         elseif not connectedAny then
            if dist < closestDist then
               closestUnconnected = other
               closestDist        = dist
            end
         end
      end

      if not connectedAny and closestUnconnected and forceConnect then
         node:connectTo(closestUnconnected)
      end
   end

   Map:build()

   for _, layer in ipairs(Map.layers) do
      for _, node in ipairs(layer) do
         if node.parents[2] then
            node.x = (node.parents[1].x + node.parents[2].x) / 2
            node.y = (node.parents[1].y + node.parents[2].y) / 2
         else
            node.x = node.parents[1].x
            node.y = node.parents[1].y
         end
      end
   end
end

function love.draw()
   love.graphics.setColor(255, 255, 255, 255)
   for _, node in ipairs(Map:getNodes()) do
      love.graphics.circle("fill", node.x, node.y, 5)

      for _, other in ipairs(node.to) do
         love.graphics.line(node.x, node.y, other.x, other.y)
      end
   end


   for _, node in ipairs(Map:getNodes(1)) do
      local dx = node.x - love.mouse.getX()
      local dy = node.y - love.mouse.getY()
      local dist = math.sqrt(dx*dx + dy* dy)

      if dist < 10 then
         love.graphics.setColor(0, 0, 255, 180)
         for _, parent in ipairs(node.parents) do
            love.graphics.circle("fill", parent.x, parent.y, 5)
         end

         love.graphics.setColor(0, 255, 0, 180)
      else
         love.graphics.setColor(255, 0, 0, 180)
      end

      love.graphics.circle("fill", node.x, node.y, 5)

      for _, other in ipairs(node.to) do
         love.graphics.line(node.x, node.y, other.x, other.y)
      end


   end
end
