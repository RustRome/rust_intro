defmodule Demo do
  def start do
    SupervisorStore.start_link
  end
end
