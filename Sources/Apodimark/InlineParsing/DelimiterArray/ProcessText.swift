//
//  ProcessText.swift
//  Apodimark
//

fileprivate enum Break {
    case spacesHardbreak
    case backslashHardbreak
    case softbreak
}

struct TextInlineNodeIterator <View: BidirectionalCollection, Codec: MarkdownParserCodec> : IteratorProtocol where
    View.Iterator.Element == Codec.CodeUnit
{
    private let view: View
    private let text: [Range<View.Index>]
    
    private var i: Int
    
    private var queuedTextInline: TextInlineNode<View>? = nil
    
    init(view: View, text: [Range<View.Index>]) {
        self.view = view
        self.text = text
        self.i = text.startIndex
    }
    
    mutating func next() -> TextInlineNode<View>? {
        
        if case let q? = queuedTextInline {
            queuedTextInline = nil
            return q
        }

        defer { i += 1 }

        guard i < text.endIndex else {
            return nil
        }
    
        let indices = text[i]
        guard !indices.isEmpty else { return nil }

        return TextInlineNode(kind: .text, start: indices.lowerBound, end: indices.upperBound)
    }
}

