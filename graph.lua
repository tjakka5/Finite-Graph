local Node = require("node")

local Graph = {}
Graph.__index = Graph

function Graph.new()
   local graph = setmetatable({
      nodes  = {},
      layers = {},
   }, Graph)

   return graph
end

function Graph:build()
   local done = false

   while not done do
      local layer  = {}
      local closed = {}

      for _, node in ipairs(self.nodes) do
         local companion = nil

         for _, other in ipairs(node.to) do
            if not closed[other] then
               companion = other

               if #other.to == 1 then
                  break
               end
            end

            print(closed[other])
         end

         local child = Node({node, companion})

         node.child = child
         if companion then
            companion.child = child

            closed[companion] = true
         end

         layer[#layer + 1] = child
      end

      self.layers[#self.layers + 1] = layer

      done = true
   end
end

function Graph:getNodes(layer)
   if not layer then
      return self.nodes
   else
      return self.layers[layer]
   end
end

function Graph:addNode()
   local node = Node()

   self.nodes[#self.nodes + 1] = node

   return node
end

return setmetatable(Graph, {
   __call = function(_, ...) return Graph.new(...) end,
})

-- Node
-- To {Node, ...}
-- From {Node, ...}
-- Parent Node
-- Children {Node, Node}
