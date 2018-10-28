class Api::BroadcastingsController < Api::ApplicationController
  def index
    broadcastings = Broadcasting.all
    respond_with broadcastings, each_serializer: ApiBroadcastingSerializer, root: false
  end
end
