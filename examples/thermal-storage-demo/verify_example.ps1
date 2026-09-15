param(
    [Parameter(Mandatory)][string]$InputPptx,
    [Parameter(Mandatory)][string]$OutputDir
)
$ErrorActionPreference='Stop'
$source=(Resolve-Path -LiteralPath $InputPptx).Path
$dest=[System.IO.Path]::GetFullPath($OutputDir)
New-Item -ItemType Directory -Path $dest -Force | Out-Null
$copy=Join-Path $dest 'edit-demo.pptx'
if ($source -eq $copy) { throw 'Input must differ from the editing copy' }
$hashBefore=(Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
$app=New-Object -ComObject PowerPoint.Application
$deck=$null
try {
    $deck=$app.Presentations.Open($source,$true,$false,$false)
    $deck.Slides.Item(1).Export((Join-Path $dest 'preview.png'),'PNG',1672,941)
    $deck.Close(); [System.Runtime.InteropServices.Marshal]::ReleaseComObject($deck)|Out-Null; $deck=$null
    Copy-Item -LiteralPath $source -Destination $copy -Force
    $deck=$app.Presentations.Open($copy,$false,$false,$false)
    $slide=$deck.Slides.Item(1)
    $slide.Shapes.Item('title').TextFrame.TextRange.Text='工业储热示例'
    $table=$slide.Shapes.Item('assumptions-table').Table
    $table.Cell(2,2).Shape.TextFrame.TextRange.Text='演示数据已修改'
    $node=$slide.Shapes.Item('heater-node');$oldTop=$node.Top;$node.Top=$oldTop+8
    $group=$slide.Shapes.Item('metric-0');$group.Left=$group.Left+4
    $plot=$slide.Shapes.Item('soc-matlab-plot');$oldPlotLeft=$plot.Left;$plot.Left=$oldPlotLeft+3
    $deck.Save();$deck.Close();[System.Runtime.InteropServices.Marshal]::ReleaseComObject($deck)|Out-Null;$deck=$null
    $deck=$app.Presentations.Open($copy,$true,$false,$false);$slide=$deck.Slides.Item(1)
    $checks=[ordered]@{
        powerpoint_version=$app.Version
        slide_count=$deck.Slides.Count
        title_edit=($slide.Shapes.Item('title').TextFrame.TextRange.Text -eq '工业储热示例')
        table_edit=($slide.Shapes.Item('assumptions-table').Table.Cell(2,2).Shape.TextFrame.TextRange.Text -eq '演示数据已修改')
        node_move=([Math]::Abs($slide.Shapes.Item('heater-node').Top-($oldTop+8)) -lt 0.1)
        node_label_preserved=($slide.Shapes.Item('heater-node').TextFrame.TextRange.Text -eq '电加热')
        connector_end_connected=($slide.Shapes.Item('grid-to-heater').ConnectorFormat.EndConnected -eq -1)
        metric_group_children=$slide.Shapes.Item('metric-0').GroupItems.Count
        plot_movable=([Math]::Abs($slide.Shapes.Item('soc-matlab-plot').Left-($oldPlotLeft+3)) -lt 0.1)
        graph_edit_mode='MATLAB or Python source regeneration; image in PPT'
        formula_edit_mode='editable text, not Office equation'
    }
    $slide.Export((Join-Path $dest 'edit-demo.png'),'PNG',1672,941)
    $checks.original_preserved=((Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash -eq $hashBefore)
    $checks.passed=($checks.slide_count -eq 1 -and $checks.title_edit -and $checks.table_edit -and $checks.node_move -and $checks.node_label_preserved -and $checks.connector_end_connected -and $checks.metric_group_children -eq 2 -and $checks.plot_movable -and $checks.original_preserved)
    $checks | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $dest 'edit-checks.json') -Encoding UTF8
    $checks | ConvertTo-Json -Depth 4
    if(-not $checks.passed){throw 'Example editing checks failed'}
} finally {
    if($deck){$deck.Close();[System.Runtime.InteropServices.Marshal]::ReleaseComObject($deck)|Out-Null}
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($app)|Out-Null
}
