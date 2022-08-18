defmodule PhxLiveStorybook.Search do
  @moduledoc false
  use PhxLiveStorybook.Web, :live_component

  alias Phoenix.LiveView.JS

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns = %{backend_module: backend_module}, socket) do
    root_path = live_storybook_path(socket, :root)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:root_path, root_path)
     |> assign(:entries, backend_module.all_leaves())
    }
  end

  def handle_event("navigate", %{"path" => path}, socket) do
   {:noreply, push_patch(socket, to: path)}
  end


  def render(assigns) do
    ~H"""
    <div id="search-container" phx-hook="SearchHook" class="lsb-hidden lsb-relative lsb-z-10 lsb-duration-300">
      <div class="lsb-fixed lsb-inset-0 lsb-bg-gray-500 lsb-bg-opacity-25 lsb-transition-opacity"></div>

      <div class="lsb-fixed lsb-inset-0 lsb-z-10 lsb-overflow-y-auto lsb-p-4 lsb-sm:p-6 lsb-md:p-20">
        <!--
          Command palette, show/hide based on modal state.

          Entering: "ease-out duration-300"
            From: "opacity-0 scale-95"
            To: "opacity-100 scale-100"
          Leaving: "ease-in duration-200"
            From: "opacity-100 scale-100"
            To: "opacity-0 scale-95"
        -->
        <div class="lsb-mx-auto lsb-max-w-xl lsb-transform lsb-divide-y lsb-divide-gray-100 lsb-overflow-hidden lsb-rounded-xl lsb-bg-white lsb-shadow-2xl lsb-ring-1 lsb-ring-black lsb-ring-opacity-5 lsb-transition-all">
          <div class="relative">
            <i class="fal fa-search lsb lsb-pointer-events-none lsb-absolute lsb-top-3.5 lsb-left-4 lsb-h-5 lsb-w-5 lsb-text-gray-400"></i>
            <input type="text" class="lsb-h-12 lsb-w-full lsb-border-0 lsb-bg-transparent lsb-pl-11 lsb-pr-4 lsb-text-gray-800 lsb-placeholder-gray-400 lsb-focus:ring-0 sm:text-sm" placeholder="Search..." role="combobox" aria-expanded="false" aria-controls="options">
          </div>

          <!-- Results, show/hide based on command palette state -->
          <ul class="lsb-max-h-72 lsb-scroll-py-2 lsb-overflow-y-auto lsb-py-2 lsb-text-sm lsb-text-gray-800">
            <!-- Active: "bg-indigo-600 text-white" -->
              <%= for {entry, i} <- Enum.with_index(@entries, 2) do %>
                <% entry_path =  @root_path <> entry.storybook_path %>

                <li class="lsb-cursor-default lsb-select-none lsb-px-4 lsb-py-2 focus:lsb-border-blue-400" tabindex={i}>
                  <%= live_patch(entry.name, to: entry_path, class: "lsb group-hover:lsb-text-indigo-600") %>
                </li>
              <% end %>
          </ul>
        </div>
      </div>
    </div>
    """
  end
end
