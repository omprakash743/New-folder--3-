trigger AccountActivation on Account (before update) {
    AccountActivationHelper.validateAccountActivation(Trigger.new);

}