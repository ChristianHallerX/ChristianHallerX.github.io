module Jekyll
  module Tags
    class CollapseTag < Liquid::Block
      def initialize(tag_name, block_options, liquid_options)
        super
        @title = block_options.strip
      end

      def render(context)
        accordionID = context["accordionID"]
        idx = context["collapsed_idx"]
        collapsedID = "#{accordionID}-collapse-#{idx}"
        headingID = "#{accordionID}-heading-#{idx}"

        # increment for the next collapsible
        context["collapsed_idx"] = idx + 1

        #site = context.registers[:site]
        #converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
        content = super

        output = <<~EOS
          <div class="card">
            <div class="card-header" id="#{headingID}">
              <h4 class="mb-0">
                <button class="btn btn-link collapsed" data-toggle="collapse" data-target="##{collapsedID}" aria-expanded="false" aria-controls="#{collapsedID}">
                  <span class="plus-minus-wrapper"><div class="plus-minus"></div></span><span class="collapse-title">#{@title}</span>
                </button>
              </h4>
            </div>
            <div id="#{collapsedID}" class="collapse" aria-labelledby="#{headingID}" data-parent="##{accordionID}">
              <div class="card-body">#{content}</div>
            </div>
          </div>
        EOS

        output
      end
    end
  end
end

Liquid::Template.register_tag('collapsible', Jekyll::Tags::CollapseTag)