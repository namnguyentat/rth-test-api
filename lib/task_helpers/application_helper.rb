module ApplicationHelper
  def self.generate_content_state(str, inlineStyleRanges = [])
    {
      entityMap: {},
      blocks: [
        {
          key: '5g99a',
          text: str,
          type: 'unstyled',
          depth: 0,
          inlineStyleRanges: inlineStyleRanges,
          entityRanges: [],
          data: {}
        }
      ]
    }.to_json
  end
end
