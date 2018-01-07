local Node = {}
Node.__index = Node

function Node.new(parents)
   return setmetatable({
      parents = parents,
      child   = nil,

      to   = {},
      from = {},
   }, Node)
end

function Node:connectTo(other)
   self.to[#self.to + 1] = other
   other.to[#other.to + 1] = self
end

function Node:connectFrom(other)
   self.from[#self.from + 1] = from
end

return setmetatable(Node, {
   __call = function(_, ...) return Node.new(...) end,
})
