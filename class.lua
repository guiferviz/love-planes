
--[[
    Creates a new class.
    You can indicate a base class if you want the new class to
    inherit from other class.

    Example of use:

        Animal = class()

        function Animal:init(name)
            print("Creating an animal")

            self.name = name
        end

        function Animal:show_name()
            print("My name is " .. self.name)
        end

        function Animal:talk()
            print("aldksjfoidjfosjidfo")
        end


        Dog = class(Animal)

        function Dog:init(name, breeds)
            Animal.init(self, name)
            print("Creating a dog")

            self.breeds = breeds
        end

        function Dog:show_name()
            Animal.show_name(self)
            print("I'm a " .. self.breeds .. " dog")
        end


        animal = Dog("Pepe", "Yorkshire")
        animal:show_name()
        animal:talk()


        -- If you modify the base class you get the
        -- same result on the derived class.
        function Animal:talk()
            print("zzzzzzzzzzzzzzzzz")
        end


        animal:talk()

    This example outputs:

        Creating an animal
        Creating a dog
        My name is Pepe
        I'm a Yorkshire dog
        aldksjfoidjfosjidfo
        zzzzzzzzzzzzzzzzz

--]]
function class(base_class)
    local new_class = {}
    new_class.__index = new_class

    function new_class:new(...)
        local o = {}
        setmetatable(o, new_class)

        if o.init then
            o:init(...)
        end

        return o
    end

    if base_class then
        base_class.__call = new_class.new
        return setmetatable(new_class, base_class)
    end

    return setmetatable(new_class, {__call = new_class.new})
end
