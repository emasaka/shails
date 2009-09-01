function <%=controller%>_controller::class.index() {
    local class=$1
    ${class}.render :action=list
}

function <%=controller%>_controller::class.list() {
    local class=$1
    ${class%_controller}.find ${class%_controller}_list :all
}

function <%=controller%>_controller::class.show() {
    local class=$1
    ${class%_controller}.find current_item :conditions="id = '$params_id'"
    ${class%_controller}.bless current_item
}

function <%=controller%>_controller::class.new() {
    local class=$1
    ${class%_controller}.new current_item
}

function <%=controller%>_controller::class.create() {
    local class=$1
    ${class%_controller}.new current_item 'params_current_item'
    current_item.save
    ${class}.redirect_to :action=list
}

function <%=controller%>_controller::class.edit() {
    local class=$1
    ${class%_controller}.find current_item :conditions="id = '$params_id'"
    ${class%_controller}.bless current_item
}

function <%=controller%>_controller::class.update() {
    local class=$1

    ${class%_controller}.find current_item :conditions="id = '$params_id'"
    ${class%_controller}.bless current_item
    current_item.update_attributes 'params_current_item'
    ${class}.redirect_to :action=show :id="$current_item_id"
}

function <%=controller%>_controller::class.destroy() {
    local class=$1

    ${class%_controller}.delete "$params_id"
    ${class}.redirect_to :action=list
}

base_controller.extend <%=controller%>_controller
