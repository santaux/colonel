module ViewsHelper
  def form_for(name, opts={}, &block)
    method = (opts[:method] == :get) ? 'GET' : 'POST'

    form_block = lambda {
      haml_concat(capture_haml {
        haml_tag :input, {type: 'hidden', name: '_method', value: opts[:method]}
      })
      haml_concat(capture_haml {
        block.call
      })
    }
    capture_haml do
      haml_tag :form, {action: opts[:url], method: method}.merge(opts[:html]), &form_block
    end
  end

  def link_to(name, url, opts={})
    opts[:'data-method'] = opts.delete(:method) if opts[:method]
    opts[:'data-confirm'] = opts.delete(:confirm) if opts[:confirm]

    capture_haml do
      haml_tag :a, {href: url}.merge(opts) do
        haml_concat name
      end
    end
  end

  def selected?(period, i)
    @job && @job.schedule.send(period).include?(i.to_s) && "selected"
  end
end
