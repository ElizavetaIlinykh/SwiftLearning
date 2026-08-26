import SwiftUI

struct TagsView: View {
    // MARK: - Public properties -

    let tags: [String]

    var body: some View {
        TagsFlowLayout(spacing: 8) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(Color.primary.opacity(0.05))
                    .clipShape(Capsule())
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Tags: \(tags.joined(separator: ", "))")
    }
}

private struct TagsFlowLayout: Layout {
    let spacing: CGFloat

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache _: inout Void
    ) -> CGSize {
        let maxWidth = proposal.width ?? 0
        let rows = makeRows(subviews: subviews, maxWidth: maxWidth)
        return CGSize(
            width: maxWidth,
            height: rows.last.map { $0.yOffset + $0.height } ?? 0
        )
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal _: ProposedViewSize,
        subviews: Subviews,
        cache _: inout Void
    ) {
        let rows = makeRows(subviews: subviews, maxWidth: bounds.width)

        for row in rows {
            for item in row.items {
                subviews[item.index].place(
                    at: CGPoint(x: bounds.minX + item.xOffset, y: bounds.minY + row.yOffset),
                    proposal: ProposedViewSize(item.size)
                )
            }
        }
    }

    private func makeRows(subviews: Subviews, maxWidth: CGFloat) -> [Row] {
        guard maxWidth > 0 else { return [] }

        var rows: [Row] = []
        var currentItems: [Item] = []
        var currentX: CGFloat = 0
        var currentHeight: CGFloat = 0
        var currentY: CGFloat = 0

        for index in subviews.indices {
            let proposedWidth = maxWidth
            let size = subviews[index].sizeThatFits(
                ProposedViewSize(width: proposedWidth, height: nil)
            )
            let itemWidth = min(size.width, maxWidth)
            let itemSize = CGSize(width: itemWidth, height: size.height)
            let nextX = currentItems.isEmpty ? itemWidth : currentX + spacing + itemWidth

            if !currentItems.isEmpty, nextX > maxWidth {
                rows.append(Row(items: currentItems, yOffset: currentY, height: currentHeight))
                currentY += currentHeight + spacing
                currentItems = []
                currentX = 0
                currentHeight = 0
            }

            let xOffset = currentItems.isEmpty ? 0 : currentX + spacing
            currentItems.append(Item(index: index, xOffset: xOffset, size: itemSize))
            currentX = xOffset + itemWidth
            currentHeight = max(currentHeight, itemSize.height)
        }

        if !currentItems.isEmpty {
            rows.append(Row(items: currentItems, yOffset: currentY, height: currentHeight))
        }

        return rows
    }

    private struct Row {
        let items: [Item]
        let yOffset: CGFloat
        let height: CGFloat
    }

    private struct Item {
        let index: Int
        let xOffset: CGFloat
        let size: CGSize
    }
}

#Preview {
    TagsView(tags: ["variables", "let", "constants", "a-very-long-tag-that-wraps-cleanly"])
        .padding()
}
