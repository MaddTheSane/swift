//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2017 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

@_exported import CoreText // Clang module

extension CTRun {
	public var advances: AnySequence<CGSize> {
		if let preAdv = __advancesPtr {
			return AnySequence(UnsafeBufferPointer(start: preAdv, count: glyphCount))
		} else {
			let preArr = [CGSize](repeating: CGSize(), count: glyphCount)
			__getAdvances(range: CFRangeMake(0, 0), &preArr)
			return AnySequence(preArr)
		}
	}
	
	public func typographicBounds(for range: CFRange) -> (width: Double, ascent: CGFloat, descent: CGFloat, leading: CGFloat) {
		var ascent: CGFloat = 0, descent: CGFloat = 0, leading: CGFloat = 0
		let width = __getTypographicBounds(range: range, ascent: &ascent, descent: &descent, leading: &leading)
		return (width, ascent, descent, leading)
	}
	
	public var glyphs: AnySequence<CGGlyph> {
		if let preGlyph = __glyphsPtr {
			return AnySequence(UnsafeBufferPointer(start: preGlyph, count: glyphCount))
		} else {
			let preArr = [CGGlyph](repeating: 0, count: glyphCount)
			__getGlyphs(range: CFRangeMake(0, 0), &preArr)
			return AnySequence(preArr)
		}
	}
	
	public var positions: AnySequence<CGPoint> {
		if let preGlyph = __positionsPtr {
			return AnySequence(UnsafeBufferPointer(start: preGlyph, count: glyphCount))
		} else {
			let preArr = [CGGlyph](repeating: CGPoint(), count: glyphCount)
			__getPositions(range: CFRangeMake(0, 0), &preArr)
			return AnySequence(preArr)
		}
	}
	
	public var stringIndices: AnySequence<CFIndex> {
		if let preGlyph = __stringIndicesPtr {
			return AnySequence(UnsafeBufferPointer(start: preGlyph, count: glyphCount))
		} else {
			let preArr = [CGGlyph](repeating: 0, count: glyphCount)
			__getStringIndices(range: CFRangeMake(0, 0), &preArr)
			return AnySequence(preArr)
		}
	}
}

extension CTFont {
		/// Return an ordered list of `CTFontDescriptor`s for font fallback derived from the system default fallback region according to the given language preferences. The style of the given is also matched as well as the weight and width of the font is not one of the system UI font, otherwise the UI font fallback is applied.
	/// - parameter languagePrefList: The language preference list - ordered array of `String`s of ISO language codes.
	/// - returns: The ordered list of fallback fonts - ordered array of `CTFontDescriptor`s.
	@available(OSX 10.8, iOS 6.0, watchOS 2.0, tvOS 9.0, *)
	public func defaultCascadeList(forLanguages languagePrefList: [String]?) -> [CTFontDescriptor]? {
		return __defaultCascadeList(forLanguages: languagePrefList as NSArray?) as! [CTFontDescriptor]?
	}
	
		/// Renders the given glyphs from the CTFont at the given positions in the CGContext.
	///
	/// This function will modify the `CGContext`'s font, text size, and text matrix if specified in the `Font`. These attributes will not be restored.
	/// The given glyphs should be the result of proper Unicode text layout operations (such as `CTLine`). Results from `glyphs(for:)` (or similar APIs) do not perform any Unicode text layout.
	/// - parameter context: `CGContext` used to render the glyphs.
	/// - parameter gp: The glyphs and positions (origins) to be rendered. The positions are in user space.
	public func draw(glyphsAndPositions gp: [(glyph: CGGlyph, position: CGPoint)], context: CGContext) {
		let glyphs = gp.map({return $0.glyph})
		let positions = gp.map({return $0.position})
		CTFontDrawGlyphs(self, glyphs, positions, gp.count, context)
	}

	// - returns: This function returns a `CGFont` for the given font reference. Additional attributes from the font will be passed back as a font descriptor via the attributes parameter.
	public var graphicsFont: (font: CGFont, attributes: CTFontDescriptor) {
		var attribs: Unmanaged<CTFontDescriptor>? = nil
		let aFont = __graphicsFont(&attribs)
		return (aFont, attribs!.takeRetainedValue())
	}

	public var supportedLangages: [String] {
		return __supportedLangages as! [String]
	}
}
