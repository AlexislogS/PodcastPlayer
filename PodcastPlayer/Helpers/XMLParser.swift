//
//  XMLParser.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 14.08.2021.
//

import Foundation

public struct XMLNode: CustomStringConvertible {
  public var name: String
  public var attributes: [String:String]
  public var children: [XMLNode]
  public var text: String
  
  public var description: String {
    let attrsStr = attributes.isEmpty ? "" : " " + (attributes.map({ "\($0.key)=\"\($0.value)\"" })).joined(separator: " ")
    if !children.isEmpty {
      return "<\(name)\(attrsStr)>\(children.map({ $0.description }).joined(separator: ""))</\(name)>"
    } else if !text.isEmpty {
      return "<\(name)\(attrsStr)>\(text)</\(name)>"
    } else {
      return "<\(name)\(attrsStr)/>"
    }
    
  }
}

public extension XMLParser {
  static func parse(contentsOf url: URL) throws -> XMLNode {
    let data = try Data(contentsOf: url)
    return try parse(data: data)
  }
  static func parse(data: Data) throws -> XMLNode {
    let parser = XMLParser(data: data)
    class ParserDelegate: NSObject, XMLParserDelegate {
      var error: Error?
      var rootNode: XMLNode!
      private var stack = [XMLNode]()
      
      func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        error = parseError
      }
      
      func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        stack.append(XMLNode(name: elementName, attributes: attributeDict, children: [], text: ""))
      }
      
      func parser(_ parser: XMLParser, foundCharacters string: String) {
        stack[stack.count - 1].text += string
      }
      
      func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        var el = stack.removeLast()
        el.text = el.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if !stack.isEmpty {
          stack[stack.count - 1].children.append(el)
        } else if rootNode == nil {
          rootNode = el
        }
      }
    }
    let delegate = ParserDelegate()
    parser.delegate = delegate
    parser.parse()
    if let err = delegate.error { throw err }
    return delegate.rootNode
  }
}
