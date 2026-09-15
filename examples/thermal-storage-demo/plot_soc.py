"""Replot fictional SOC data with Python/Matplotlib; MATLAB is optional."""
import argparse
import json
from pathlib import Path

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt


def plot(output_dir):
    data = json.loads((Path(__file__).parent/'data.json').read_text(encoding='utf-8'))
    values = [v*100 for v in data['soc_series']]
    if len(values) != 6 or any(v < 0 or v > 100 for v in values):
        raise ValueError('Expected six SOC percentages between 0 and 100')
    output_dir.mkdir(parents=True, exist_ok=True)
    plt.rcParams.update({'font.family':'DejaVu Sans','font.size':12,'svg.fonttype':'none'})
    fig, ax = plt.subplots(figsize=(6.5,2.73),dpi=300)
    fig.subplots_adjust(left=.135,right=.965,bottom=.18,top=.92)
    x=[0,4,8,12,16,20]
    ax.plot(x,values,'-o',color='#078C95',linewidth=1.8,markersize=6)
    ax.plot(x[3],values[3],'o',color='#EF931D',markersize=7)
    ax.set(xlim=(-.7,20.7),ylim=(0,100),xticks=x,xticklabels=data['times'],yticks=[0,50,100],yticklabels=['0%','50%','100%'])
    ax.grid(True,linestyle='--',color='#9AAFC0',alpha=.35)
    ax.spines[['top','right']].set_visible(False)
    ax.spines[['left','bottom']].set_color('#16324F')
    ax.tick_params(colors='#16324F',length=3)
    for i,(xx,yy) in enumerate(zip(x,values)):
        ax.text(xx,yy+5,f'{yy:g}%',ha='center',va='bottom',fontsize=11,color='#EF931D' if i==3 else '#16324F')
    for extension in ['png','svg']:
        fig.savefig(output_dir/f'soc-curve.{extension}',dpi=300,facecolor='white')
    plt.close(fig)
    print(output_dir)


if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--out-dir',type=Path,default=Path(__file__).parent)
    plot(ap.parse_args().out_dir)
