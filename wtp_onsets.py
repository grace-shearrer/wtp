import glob
import os
import numpy
#import fnmatch
#the onset time stuff isn't necessary here, though it should be noted there was a variable jitter between task times
#making a data dictionary of the foods possible
#all of the indents are wrong need to fix
data_dic={}
data_dic['high_sug_low_fat']={}
data_dic['high_sug_high_fat']={}
data_dic['low_sug_high_fat']={}
data_dic['low_sug_low_fat']={}

f=open('/Users/nibl/Google Drive/BDM/highfat_highsugar.txt','r')
f2 = f.readlines()
a=[]
for line in f2:
    p=line.strip()
    a.append(p)
    
g=open('/Users/nibl/Google Drive/BDM/highsugar_lowfat.txt','r')
g2 = g.readlines()
b=[]
for line in g2:
    p=line.strip()
    b.append(p)

h=open('/Users/nibl/Google Drive/BDM/lowfat_lowsugar.txt','r')
h2 = h.readlines()
c=[]
for line in h2:
    p=line.strip()
    c.append(p)
    
j=open('/Users/nibl/Google Drive/BDM/highfat_lowsugar.txt','r')
j2 = j.readlines()
d=[]
for line in j2:
    p=line.strip()
    d.append(p)
#############    
#############
data_dic['low_sug_high_fat']=d
data_dic['high_sug_high_fat']=a
data_dic['low_sug_low_fat']=c
data_dic['high_sug_low_fat']=b
##########################
#starting the parser#
##########################
basepath='/Users/nibl/Google Drive/BDM/'
os.chdir(basepath)
print basepath
for file in glob.glob('sb_00*/wtp/*'):
    print file
    for dir in glob.glob('sb_00*/'):
        print dir
        os.chdir(os.path.join(basepath,dir,'wtp'))
        newpath=os.path.join(basepath,dir,'wtp')
        f=glob.glob('Ons*.txt')
        print(f)
            #make all the initial lists#
        onsets=[]
        conds=[]
        #task=[]
        #rt=[]
        HFHS=[]#high fat high sugar
        LFHS=[]#low fat high sugar
        LFLS=[]#low fat low sugar
        HFLS=[]#high fat low sugar
        miss=[]
        handles=[]
        #open .txt files#
        for l in f:
            handles.append(open(l))
        for logfile_handle in range(0,len(handles)):
            for x in handles[logfile_handle].readlines()[1:]:
                l_s=x.strip().split()
                onsets.append(float(l_s[3]))#pulling onsets
                onsets2=numpy.sort(onsets)
                conds.append(l_s[3:6])#pulling out conditions and bids
                #task.append(int(l_s[5]))#pulling out bids
                #rt.append(int(l_s[6]))#pulling out conds
                base_filename="run0"+str(logfile_handle+1)
                print(base_filename)
        #start_time=onsets[0]
                print conds    
            #fill HSHF condition
                for line in conds:
                    if line[1] in data_dic['low_sug_high_fat']:
                        HFLS.append(line)#1 if it is HFHS
                    elif line[1] in data_dic['high_sug_high_fat']:
                        HFHS.append(line)
                    elif line[1] in data_dic['low_sug_low_fat']:
                        LFLS.append(line)
                    elif line[1] in data_dic['high_sug_low_fat']:
                        LFHS.append(line)
        #print HFLS
        #print HFHS
        #print LFLS
        #print LFHS
                
                HFLS_onsets=[]
                HFLS_bid=[]
                for line in HFLS:
                    HFLS_onsets.append(float(line[0]))
                    HFLS_onsets2=numpy.sort(HFLS_onsets)
                    HFLS_bid.append(int(line[2]))
        #miss_HFLS=numpy.zeros(len(HFLS_bid))
        #miss_HFLS[numpy.array(HFLS_bid)==999]=1

                HFHS_onsets=[]
                HFHS_bid=[]        
                for line in HFHS:
                    HFHS_onsets.append(float(line[0]))
                    HFHS_onsets2=numpy.sort(HFHS_onsets)
                    HFHS_bid.append(int(line[2]))
        #miss_HFHS=numpy.zeros(len(HFHS_bid))
        #miss_HFHS[numpy.array(HFHS_bid)==999]=1

            LFLS_onsets=[]
            LFLS_bid=[]        
            for line in LFLS:
                LFLS_onsets.append(float(line[0]))
                LFLS_onsets2=numpy.sort(LFLS_onsets)
                LFLS_bid.append(int(line[2]))
        #miss_LFLS=numpy.zeros(len(LFLS_bid))
        #miss_LFLS[numpy.array(LFLS_bid)==999]=1

            LFHS_onsets=[]
            LFHS_bid=[]        
            for line in LFHS:
                LFHS_onsets.append(float(line[0]))
                LFHS_onsets2=numpy.sort(LFHS_onsets)
                LFHS_bid.append(int(line[2]))
        #miss_LFHS=numpy.zeros(len(LFHS_bid))
        #miss_LFHS[numpy.array(LFHS_bid)==999]=1


                            
            f_HFLSoutcome=open('highfat_lowsug_'+base_filename+'.txt', 'w')
            f_HFHSoutcome=open('highfat_highsug_'+base_filename+'.txt', 'w')
            f_LFHSoutcome=open('lowfat_highsug_'+base_filename+'.txt', 'w')
            f_LFLSoutcome=open('lowfat_lowsug_'+base_filename+'.txt', 'w')

        #f_HFLSmiss=open('highfat_lowsug_miss_'+base_filename+'.txt', 'w')
        #f_HFHSmiss=open('highfat_highsug_miss_'+base_filename+'.txt', 'w')
        #f_LFHSmiss=open('lowfat_highsug_miss_'+base_filename+'.txt', 'w')
        #f_LFLSmiss=open('lowfat_lowsug_miss_'+base_filename+'.txt', 'w')
        
            f_task=open('task_'+base_filename+'.txt', 'w')


            for t in range(len(HFLS_onsets2)):
                f_HFLSoutcome.write('%f\t2\t%d\n' %(HFLS_onsets2[t], HFLS_bid[t]))
            #f_HFLSmiss.write('%f\t2\t%d\n' %(HFLS_onsets2[t], miss_HFLS[t]))
            f_HFLSoutcome.close()
        #f_HFLSmiss.close()

            for t in range(len(HFHS_onsets2)):
                f_HFHSoutcome.write('%f\t2\t%d\n' %(HFHS_onsets2[t], HFHS_bid[t]))
        #    f_HFHSmiss.write('%f\t2\t%d\n' %(HFHS_onsets2[t], miss_HFHS[t]))
            f_HFHSoutcome.close()
        #f_HFHSmiss.close()
        
            for t in range(len(LFHS_onsets2)):
                f_LFHSoutcome.write('%f\t2\t%d\n' %(LFHS_onsets2[t], LFHS_bid[t]))
         #   f_LFHSmiss.write('%f\t2\t%d\n' %(LFHS_onsets2[t], miss_LFHS[t]))
            f_LFHSoutcome.close()   
        #f_LFHSmiss.close()          

            for t in range(len(LFLS_onsets2)):
                f_LFLSoutcome.write('%f\t2\t%d\n' %(LFLS_onsets2[t], LFLS_bid[t]))
         #   f_LFLSmiss.write('%f\t2\t%d\n' %(LFLS_onsets2[t], miss_LFLS[t]))
            f_LFLSoutcome.close()
        #f_LFLSmiss.close()
        
            for t in range(len(onsets2)):
                f_task.write('%f\t4\t1\n' %onsets2[t])                        
            f_task.close()
        
