

function New-CardTextRun {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Text,
        [Parameter(Mandatory = $false)]
        [ValidateSet("Default","Dark","Light","Accent","Good","Warning","Attention",$null)]
        [string]$Color,
        
        [Parameter(Mandatory = $false)]
        [string]
        $Id,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Default","Monospace",$null)]
        [string]$FontType,
        [string]$Lang,
        [scriptblock]$SelectAction,
        [ValidateSet("Small","Default","Medium","Large","ExtraLarge",$null)]
        [string]$Size,
        [ValidateSet("Lighter","Default","Bolder",$null)]
        [string]$Weight,
        
        [switch]$IsVisible,
        [switch]$IsSubtle,
        [switch]$Highlight,
        [switch]$Italic,
        [switch]$Strikethrough,
        [switch]$Underline
    )
    

    $TextRun = @{
        type = "TextRun"
        text = $Text
    }

    if ($Color) {
        $TextRun.color = $Color
    }

    if ($Id) {
        $TextRun.id = $Id
    }

    if ($FontType) {
        $TextRun.fontType = $FontType
    }

    if ($IsSubtle) {
        $TextRun.isSubtle = $true
    }

    if ($IsVisible) {
        $TextRun.isVisible = $true
    }

    if ($Lang) {
        $TextRun.lang = $Lang
    }

    if ($SelectAction) {
        $TextRun.selectAction = Invoke-Command -ScriptBlock $SelectAction
    }

    if ($Size) {
        $TextRun.size = $Size
    }

    if ($Weight) {
        $TextRun.weight = $Weight
    }

    if ($Highlight) {
        $TextRun.highlight = $true
    }

    if ($Italic) {
        $TextRun.italic = $true
    }

    if ($Strikethrough) {
        $TextRun.strikethrough = $true
    }

    if ($Underline) {
        $TextRun.underline = $true
    }

    return $TextRun
}
<#type
string
Must be TextRun.

1.0
highlight
boolean
false
Controls if the text should be highlighted.

1.2
italic
boolean
false
Controls if the text should be italicized.

1.2
strikethrough
boolean
false
Controls if the text should be struck through.

1.2
underline
boolean
false
Controls if the text should be underlined.

1.3
color
string
The color of the text.

Valid values: 
"Default",
"Dark",
"Light",
"Accent",
"Good",
"Warning",
"Attention"
1.0
fallback
One of
object
string
An alternate element to render if the type of this one is unsupported or if the host application doesn't support all the capabilities specified in the requires property.

Valid values: 
Container,
ActionSet,
ColumnSet,
Media,
RichTextBlock,
Table,
TextBlock,
FactSet,
ImageSet,
Image,
Input.Text,
Input.Date,
Input.Time,
Input.Number,
Input.Toggle,
Input.ChoiceSet,
Input.Rating,
Rating,
CompoundButton,
Icon,
Carousel,
Badge,
ProgressRing,
ProgressBar,
Chart.Donut,
Chart.Pie,
Chart.VerticalBar.Grouped,
Chart.VerticalBar,
Chart.HorizontalBar,
Chart.HorizontalBar.Stacked,
Chart.Line,
Chart.Gauge,
CodeBlock,
Component.graph.microsoft.com/user,
Component.graph.microsoft.com/users,
Component.graph.microsoft.com/resource,
Component.graph.microsoft.com/file,
Component.graph.microsoft.com/event,
"drop"
1.2
fontType
string
The type of font to use for rendering.

Valid values: 
"Default",
"Monospace"
1.2
grid.area
string
Teams
The area of a Layout.AreaGrid layout in which an element should be displayed.

1.5
id
string
A unique identifier for the element or action. Input elements must have an id, otherwise they will not be validated and their values will not be sent to the Bot.

1.0
isSortKey
boolean
false
Controls whether the element should be used as a sort key by elements that allow sorting across a collection of elements.

1.5
isSubtle
boolean
Controls whether the text should be renderer using a subtler variant of the select color.

1.0
isVisible
boolean
true
Controls the visibility of the element.

1.2
lang
string
The locale associated with the element.

1.1
selectAction
object
An Action that will be invoked when the text is tapped or clicked. Action.ShowCard is not supported.

Valid values: 
Action.Execute,
Action.InsertImage,
Action.OpenUrl,
Action.OpenUrlDialog,
Action.Popover,
Action.ResetInputs,
Action.Submit,
Action.ToggleVisibility
1.1
size
string
The size of the text.

Valid values: 
"Small",
"Default",
"Medium",
"Large",
"ExtraLarge"
1.0
text
string
The text to display. A subset of markdown is supported.

1.0
weight
string
The weight of the text.

Valid values: 
"Lighter",
"Default",
"Bolder"#>