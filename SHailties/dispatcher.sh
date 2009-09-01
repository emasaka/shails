function Dispatcher.dispatch() {
    route.recognize "$REQUEST_URI"
    ${params_controller}_controller.render :action="${params_action}"
    resultset.cleanmine
}
